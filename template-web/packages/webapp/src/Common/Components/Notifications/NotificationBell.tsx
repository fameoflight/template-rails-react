import React, { useState, useEffect } from 'react';
import { Badge, Dropdown, List, Typography, Button, Empty, Spin } from 'antd';
import { BellOutlined, CheckOutlined, SettingOutlined } from '@ant-design/icons';
import { useNotificationChannel } from '../../hooks/useActionCable';
import { graphql } from 'react-relay/hooks';
import { useNetworkLazyLoadQuery, commitCompatMutation } from '@picasso/shared/src/relay/hooks';

import type { NotificationBellQuery } from '@picasso/fragments/src/NotificationBellQuery.graphql';
import type { NotificationBellMarkAsReadMutation } from '@picasso/fragments/src/NotificationBellMarkAsReadMutation.graphql';
import type { NotificationBellMarkAllAsReadMutation } from '@picasso/fragments/src/NotificationBellMarkAllAsReadMutation.graphql';

const { Text } = Typography;

const NOTIFICATIONS_QUERY = graphql`
  query NotificationBellQuery {
    notifications(first: 10) {
      edges {
        node {
          id
          title
          message
          notificationType
          read
          createdAt
          icon
          color
        }
      }
    }
    unreadNotificationCount
  }
`;

const MARK_NOTIFICATION_READ_MUTATION = graphql`
  mutation NotificationBellMarkAsReadMutation($input: NotificationMarkAsReadInput!) {
    notificationMarkAsRead(input: $input) {
      notification {
        id
        read
      }
      unreadCount
      errors
    }
  }
`;

const MARK_ALL_NOTIFICATIONS_READ_MUTATION = graphql`
  mutation NotificationBellMarkAllAsReadMutation($input: NotificationMarkAllAsReadInput!) {
    notificationMarkAllAsRead(input: $input) {
      success
      unreadCount
      errors
    }
  }
`;

interface Notification {
  id: string;
  title: string;
  message: string;
  notificationType: string;
  read: boolean;
  createdAt: string;
  icon: string;
  color: string;
}

interface NotificationBellProps {
  userId: string; // This will be the encrypted GraphQL ID
  maxDisplayCount?: number;
  className?: string;
}

export default function NotificationBell({ 
  userId, 
  maxDisplayCount = 10, 
  className = "" 
}: NotificationBellProps) {
  const [dropdownVisible, setDropdownVisible] = useState(false);
  
  // Load initial notifications using GraphQL
  const data = useNetworkLazyLoadQuery<NotificationBellQuery>(NOTIFICATIONS_QUERY, {});
  
  const notifications: Notification[] = (data?.notifications?.edges?.map(edge => edge?.node).filter(Boolean) || []) as Notification[];
  const [localUnreadCount, setLocalUnreadCount] = useState(data?.unreadNotificationCount || 0);
  
  // Use local state to track unread count for immediate UI updates
  useEffect(() => {
    setLocalUnreadCount(data?.unreadNotificationCount || 0);
  }, [data?.unreadNotificationCount]);
  
  console.log('🔔 NotificationBell GraphQL data:', { notifications: notifications.length, unreadCount: localUnreadCount, userId });

  // No need to store mutation hooks, we'll use commitCompatMutation directly

  // Set up real-time updates
  const { isConnected } = useNotificationChannel(userId, (data) => {
    console.log('🔔 Real-time notification data received:', data);
    
    if (data.type === 'notification') {
      const newNotification = data.notification;
      console.log('🔔 Adding new notification:', newNotification);
      setLocalUnreadCount(prev => prev + 1);
      
      // Show browser notification if permission granted
      if (Notification.permission === 'granted') {
        new Notification(newNotification.title, {
          body: newNotification.message,
          icon: '/favicon.ico'
        });
      }
      
      // Refetch notifications to get latest data
      // Note: In a real app, you might want to update the relay store directly
    } else if (data.type === 'unread_count_update') {
      console.log('🔔 Updating unread count to:', data.unread_count);
      setLocalUnreadCount(data.unread_count);
    }
  });

  // Request notification permission on mount
  useEffect(() => {
    if (Notification.permission === 'default') {
      Notification.requestPermission();
    }
  }, []);

  const markAsRead = async (notificationId: string) => {
    try {
      commitCompatMutation<NotificationBellMarkAsReadMutation>({
        mutation: MARK_NOTIFICATION_READ_MUTATION,
        variables: { 
          input: { notificationId } 
        },
        onCompleted: (response) => {
          if (response.notificationMarkAsRead?.errors?.length === 0) {
            setLocalUnreadCount(response.notificationMarkAsRead.unreadCount);
            console.log('🔔 Marked notification as read:', notificationId);
          } else {
            console.error('Failed to mark notification as read:', response.notificationMarkAsRead?.errors);
          }
        },
        onError: (error) => {
          console.error('Failed to mark notification as read:', error);
        }
      });
    } catch (error) {
      console.error('Failed to mark notification as read:', error);
    }
  };

  const markAllAsRead = async () => {
    try {
      commitCompatMutation<NotificationBellMarkAllAsReadMutation>({
        mutation: MARK_ALL_NOTIFICATIONS_READ_MUTATION,
        variables: { 
          input: {} 
        },
        onCompleted: (response) => {
          if (response.notificationMarkAllAsRead?.success) {
            setLocalUnreadCount(0);
            console.log('🔔 Marked all notifications as read');
          } else {
            console.error('Failed to mark all notifications as read:', response.notificationMarkAllAsRead?.errors);
          }
        },
        onError: (error) => {
          console.error('Failed to mark all notifications as read:', error);
        }
      });
    } catch (error) {
      console.error('Failed to mark all notifications as read:', error);
    }
  };

  const dropdownContent = (
    <div style={{ 
      width: 360, 
      maxHeight: 480, 
      overflowY: 'auto',
      backgroundColor: 'white',
      border: '1px solid #d9d9d9',
      borderRadius: '8px',
      boxShadow: '0 4px 12px rgba(0, 0, 0, 0.15)'
    }}>
      <div style={{ 
        padding: '16px 20px', 
        borderBottom: '1px solid #f0f0f0',
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center',
        backgroundColor: '#fafafa'
      }}>
        <Text strong style={{ fontSize: '16px' }}>Notifications</Text>
        {localUnreadCount > 0 && (
          <Button 
            size="small" 
            type="link"
            icon={<CheckOutlined />}
            onClick={markAllAsRead}
            style={{ color: '#1890ff' }}
          >
            Mark all read
          </Button>
        )}
      </div>
      
      {notifications.length === 0 ? (
        <Empty 
          description="No notifications yet"
          style={{ padding: '40px' }}
          image={Empty.PRESENTED_IMAGE_SIMPLE}
        />
      ) : (
        <List
          dataSource={notifications}
          renderItem={(notification) => (
            <List.Item 
              key={notification.id}
              style={{ 
                backgroundColor: notification.read ? 'white' : '#e6f7ff',
                padding: '16px 20px',
                borderBottom: '1px solid #f0f0f0',
                cursor: 'pointer',
                transition: 'background-color 0.3s',
                margin: 0
              }}
              onClick={() => !notification.read && markAsRead(notification.id)}
              onMouseEnter={(e) => {
                e.currentTarget.style.backgroundColor = notification.read ? '#fafafa' : '#bae7ff';
              }}
              onMouseLeave={(e) => {
                e.currentTarget.style.backgroundColor = notification.read ? 'white' : '#e6f7ff';
              }}
            >
              <List.Item.Meta
                avatar={
                  <div style={{
                    width: 40,
                    height: 40,
                    borderRadius: '50%',
                    backgroundColor: notification.read ? '#f0f0f0' : '#1890ff',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    fontSize: '16px',
                    color: notification.read ? '#666' : 'white'
                  }}>
                    <BellOutlined />
                  </div>
                }
                title={
                  <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                    <Text 
                      strong={!notification.read}
                      style={{ 
                        fontSize: '14px',
                        color: notification.read ? '#666' : '#262626'
                      }}
                    >
                      {notification.title}
                    </Text>
                    {!notification.read && (
                      <div style={{
                        width: 8,
                        height: 8,
                        borderRadius: '50%',
                        backgroundColor: '#ff4d4f',
                        flexShrink: 0
                      }} />
                    )}
                  </div>
                }
                description={
                  <div>
                    <Text style={{ 
                      fontSize: '13px', 
                      color: notification.read ? '#999' : '#595959',
                      display: 'block',
                      marginBottom: '4px'
                    }}>
                      {notification.message}
                    </Text>
                    <Text type="secondary" style={{ fontSize: '12px' }}>
                      {new Date(notification.createdAt).toLocaleString()}
                    </Text>
                  </div>
                }
              />
            </List.Item>
          )}
        />
      )}
    </div>
  );

  return (
    <Dropdown
      dropdownRender={() => dropdownContent}
      trigger={['click']}
      placement="bottomRight"
      open={dropdownVisible}
      onOpenChange={setDropdownVisible}
    >
      <div 
        className={`cursor-pointer hover:bg-white hover:bg-opacity-20 rounded-md p-2 transition-colors ${className}`}
        style={{ display: 'flex', alignItems: 'center' }}
      >
        <Badge 
          count={localUnreadCount} 
          size="small"
          style={{ backgroundColor: '#ff4d4f' }}
        >
          <BellOutlined 
            style={{ 
              fontSize: '18px', 
              color: 'white',
              opacity: isConnected ? 1 : 0.5
            }} 
          />
        </Badge>
        {!isConnected && (
          <div 
            style={{
              position: 'absolute',
              top: 0,
              right: 0,
              width: 6,
              height: 6,
              borderRadius: '50%',
              backgroundColor: '#ff4d4f',
              border: '1px solid white'
            }}
          />
        )}
      </div>
    </Dropdown>
  );
}