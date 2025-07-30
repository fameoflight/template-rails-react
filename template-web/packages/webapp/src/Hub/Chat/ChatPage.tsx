import React, { useState } from 'react';
import { Card, Input, Button, Space, Typography } from 'antd';
import ChatRoom from '../../Common/Components/Chat/ChatRoom';
import { useAuthContext } from '@picasso/shared/src/context/authContext';

const { Title, Text } = Typography;

export default function ChatPage() {
  const [roomId, setRoomId] = useState('general');
  const [customRoomId, setCustomRoomId] = useState('');
  const { currentUser } = useAuthContext();

  const joinRoom = () => {
    if (customRoomId.trim()) {
      setRoomId(customRoomId.trim());
      setCustomRoomId('');
    }
  };

  return (
    <div style={{ padding: '24px', maxWidth: '800px', margin: '0 auto' }}>
      <Title level={2}>Chat Rooms</Title>
      
      <Card style={{ marginBottom: '24px' }}>
        <Space direction="vertical" style={{ width: '100%' }}>
          <Text>Current Room: <strong>{roomId}</strong></Text>
          
          <Space>
            <Button 
              type={roomId === 'general' ? 'primary' : 'default'}
              onClick={() => setRoomId('general')}
            >
              General
            </Button>
            <Button 
              type={roomId === 'random' ? 'primary' : 'default'}
              onClick={() => setRoomId('random')}
            >
              Random
            </Button>
          </Space>
          
          <Space.Compact style={{ width: '100%' }}>
            <Input
              placeholder="Enter custom room ID"
              value={customRoomId}
              onChange={(e) => setCustomRoomId(e.target.value)}
              onPressEnter={joinRoom}
            />
            <Button type="primary" onClick={joinRoom}>
              Join Room
            </Button>
          </Space.Compact>
        </Space>
      </Card>

      <ChatRoom 
        roomId={roomId} 
        currentUser={currentUser ? {
          id: currentUser.id,
          name: currentUser.name || 'Anonymous'
        } : undefined}
      />
    </div>
  );
}