import React, { useState, useEffect, useRef } from 'react';
import { Button, Input, List, Avatar, Typography, Space, Card } from 'antd';
import { SendOutlined } from '@ant-design/icons';
import { createConsumer } from '@rails/actioncable';
import jTokerAuthProvider from '@picasso/shared/src/api/jTokerAuthProvider';
import TypingIndicator from './TypingIndicator';
import { useCompatMutation, commitCompatMutation } from '@picasso/shared/src/relay/hooks';
import { graphql } from 'react-relay/hooks';
import api from '@picasso/shared/src/api';

const { TextArea } = Input;
const { Text } = Typography;

interface Message {
  id: string;
  content: string;
  user: {
    id: string;
    name: string;
  };
  createdAt: string;
}

interface ChatRoomProps {
  roomId: string;
  currentUser?: {
    id: string;
    name: string;
  };
}


const MESSAGE_SUBSCRIPTION = `
  subscription MessageAddedSubscription($roomId: String!) {
    messageAdded(roomId: $roomId) {
      id
      content
      createdAt
      user {
        id
        name
      }
    }
  }
`;

const CREATE_MESSAGE_MUTATION = graphql`
  mutation ChatRoomCreateMessageMutation($content: String!, $roomId: String!) {
    messageCreate(content: $content, roomId: $roomId) {
      message {
        id
        content
        createdAt
        user {
          id
          name
        }
      }
      errors
    }
  }
`;

export default function ChatRoom({ roomId, currentUser }: ChatRoomProps) {
  const [messages, setMessages] = useState<Message[]>([]);
  const [newMessage, setNewMessage] = useState('');
  const [loading, setLoading] = useState(false);
  const [typingUsers, setTypingUsers] = useState<any[]>([]);
  const messagesEndRef = useRef<HTMLDivElement>(null);
  const actionCableRef = useRef<any>(null);
  const typingTimeoutRef = useRef<NodeJS.Timeout | null>(null);
  const isTypingRef = useRef(false);

  // Handle typing updates
  const handleTypingUpdate = (data: { user: any; is_typing: boolean }) => {
    console.log('⌨️ Typing update:', data);
    const { user, is_typing } = data;
    
    setTypingUsers(prev => {
      if (is_typing) {
        // Add user to typing list if not already there
        const exists = prev.some(u => u.id === user.id);
        if (!exists) {
          return [...prev, user];
        }
        return prev;
      } else {
        // Remove user from typing list
        return prev.filter(u => u.id !== user.id);
      }
    });
  };

  // Direct ActionCable connection - more stable
  const consumerRef = useRef<any>(null);
  const subscriptionRef = useRef<any>(null);
  const [isConnected, setIsConnected] = useState(false);

  useEffect(() => {
    // Setup ActionCable connection once
    const setupConnection = () => {
      const wsUrl = process.env.NODE_ENV === 'production' 
        ? 'wss://api.usepicasso.com/cable'
        : 'ws://localhost:5001/cable';

      try {
        const authHeaders = jTokerAuthProvider.getAuthHeaders();
        if (authHeaders && authHeaders['access-token']) {
          const params = new URLSearchParams({
            'access-token': authHeaders['access-token'] || '',
            'client': authHeaders['client'] || '',
            'uid': authHeaders['uid'] || ''
          });
          
          const finalUrl = `${wsUrl}?${params.toString()}`;
          console.log('🔌 Creating ActionCable consumer for room:', roomId);
          
          consumerRef.current = createConsumer(finalUrl);
          
          subscriptionRef.current = consumerRef.current.subscriptions.create(
            { channel: 'ChatChannel', room_id: roomId },
            {
              connected: () => {
                console.log('✅ Connected to ChatChannel for room:', roomId);
                setIsConnected(true);
              },
              
              disconnected: () => {
                console.log('❌ Disconnected from ChatChannel');
                setIsConnected(false);
              },
              
              received: (data: any) => {
                console.log('📨 Received data:', data);
                
                if (data.type === 'message_added' && data.message) {
                  console.log('✅ Adding new message:', data.message);
                  setMessages(prev => {
                    const exists = prev.some(msg => msg.id === data.message.id);
                    if (!exists) {
                      return [...prev, data.message];
                    }
                    return prev;
                  });
                  scrollToBottom();
                } else if (data.type === 'typing_update') {
                  handleTypingUpdate(data);
                }
              }
            }
          );
        }
      } catch (error) {
        console.error('❌ Failed to setup ActionCable:', error);
      }
    };

    setupConnection();

    // Cleanup on unmount or roomId change
    return () => {
      console.log('🧹 Cleaning up ActionCable connection');
      if (subscriptionRef.current) {
        subscriptionRef.current.unsubscribe();
        subscriptionRef.current = null;
      }
      if (consumerRef.current) {
        consumerRef.current.disconnect();
        consumerRef.current = null;
      }
      setIsConnected(false);
    };
  }, [roomId]); // Only reconnect when roomId changes

  const perform = (action: string, data: any = {}) => {
    if (subscriptionRef.current) {
      subscriptionRef.current.perform(action, data);
    }
  };

  // Simple typing functions with timeout
  const startTyping = () => {
    console.log('🎯 Starting typing indicator');
    
    // Clear any existing timeout
    if (typingTimeoutRef.current) {
      clearTimeout(typingTimeoutRef.current);
    }
    
    // Only send start_typing if not already typing
    if (!isTypingRef.current && isConnected && perform) {
      perform('start_typing', {});
      isTypingRef.current = true;
    }
    
    // Set timeout to auto-stop typing after 3 seconds
    typingTimeoutRef.current = setTimeout(() => {
      stopTyping();
    }, 3000);
  };

  const stopTyping = () => {
    console.log('🎯 Stopping typing indicator');
    
    // Clear timeout
    if (typingTimeoutRef.current) {
      clearTimeout(typingTimeoutRef.current);
      typingTimeoutRef.current = null;
    }
    
    // Only send stop_typing if currently typing
    if (isTypingRef.current && isConnected && perform) {
      perform('stop_typing', {});
      isTypingRef.current = false;
    }
  };

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  };

  useEffect(() => {
    // Load initial messages using REST API
    const loadMessages = async () => {
      try {
        const response = await api.browserRequestClient().get({
          endpoint: '/api/internal/messages',
          params: { room_id: roomId, limit: 50 }
        });
        if (response.data.messages) {
          setMessages(response.data.messages);
        }
      } catch (error) {
        console.error('Failed to load messages:', error);
      }
    };

    loadMessages();
  }, [roomId]);

  useEffect(() => {
    scrollToBottom();
  }, [messages]);

  // Cleanup typing timeout on unmount
  useEffect(() => {
    return () => {
      if (typingTimeoutRef.current) {
        clearTimeout(typingTimeoutRef.current);
      }
      // Send stop typing when component unmounts
      stopTyping();
    };
  }, []);

  const sendMessage = () => {
    if (!newMessage.trim() || !currentUser) return;

    setLoading(true);
    
    // Stop typing indicator when sending message
    stopTyping();
    
    commitCompatMutation({
      mutation: CREATE_MESSAGE_MUTATION,
      variables: {
        content: newMessage.trim(),
        roomId
      },
      onCompleted: (response: any) => {
        console.log('Message creation response:', response);
        if (response.messageCreate.errors.length === 0) {
          setNewMessage('');
          console.log('Message created successfully:', response.messageCreate.message);
          
          // Add message locally immediately for instant feedback
          // The subscription should handle broadcasting to other users
          if (response.messageCreate.message) {
            setMessages(prev => [...prev, response.messageCreate.message]);
            scrollToBottom();
          }
        } else {
          console.error('Message creation errors:', response.messageCreate.errors);
        }
        setLoading(false);
      },
      onError: (error: any) => {
        console.error('Message creation error:', error);
        setLoading(false);
      }
    });
  };

  const handleKeyPress = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      sendMessage();
    }
  };

  if (!currentUser) {
    return (
      <Card>
        <Text>Please sign in to participate in the chat.</Text>
      </Card>
    );
  }

  return (
    <Card 
      title={`Chat Room: ${roomId}`}
      style={{ height: '600px', display: 'flex', flexDirection: 'column' }}
      bodyStyle={{ display: 'flex', flexDirection: 'column', height: '100%', padding: 0 }}
    >
      <div style={{ flex: 1, overflow: 'auto', padding: '16px' }}>
        <List
          dataSource={messages}
          renderItem={(message) => (
            <List.Item key={message.id} style={{ padding: '8px 0' }}>
              <List.Item.Meta
                avatar={
                  <Avatar>
                    {message.user.name?.charAt(0).toUpperCase() || 'U'}
                  </Avatar>
                }
                title={
                  <Space>
                    <Text strong>{message.user.name || 'Anonymous'}</Text>
                    <Text type="secondary" style={{ fontSize: '12px' }}>
                      {new Date(message.createdAt).toLocaleTimeString()}
                    </Text>
                  </Space>
                }
                description={
                  <div style={{ whiteSpace: 'pre-wrap' }}>
                    {message.content}
                  </div>
                }
              />
            </List.Item>
          )}
        />
        <TypingIndicator 
          typingUsers={typingUsers} 
          currentUserId={currentUser?.id} 
        />
        <div ref={messagesEndRef} />
      </div>
      
      <div style={{ padding: '16px', borderTop: '1px solid #f0f0f0' }}>
        <Space.Compact style={{ width: '100%' }}>
          <TextArea
            value={newMessage}
            onChange={(e) => {
              setNewMessage(e.target.value);
              // Trigger typing indicator when user types
              if (e.target.value.trim()) {
                startTyping();
              }
            }}
            onKeyPress={(e) => {
              handleKeyPress(e);
              // Start typing on any key press
              startTyping();
            }}
            placeholder="Type your message..."
            autoSize={{ minRows: 1, maxRows: 4 }}
            style={{ flex: 1 }}
          />
          <Button
            type="primary"
            icon={<SendOutlined />}
            onClick={sendMessage}
            loading={loading}
            disabled={!newMessage.trim()}
          >
            Send
          </Button>
        </Space.Compact>
      </div>
    </Card>
  );
}