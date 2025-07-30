import React, { useState, useEffect } from 'react';
import { Badge, Card, List, Typography, Button } from 'antd';
import { BellOutlined, CheckOutlined } from '@ant-design/icons';
import { useNotificationChannel } from '../../hooks/useActionCable';

const { Text } = Typography;

interface Notification {
  id: string;
  title: string;
  message: string;
  type: 'info' | 'success' | 'warning' | 'error';
  read: boolean;
  createdAt: string;
}

interface LiveNotificationsProps {
  userId: string;
  onNotificationReceived?: (notification: Notification) => void;
}

export default function LiveNotifications({ userId, onNotificationReceived }: LiveNotificationsProps) {
  const [notifications, setNotifications] = useState<Notification[]>([]);
  const [unreadCount, setUnreadCount] = useState(0);

  // Use the notification channel hook
  const { isConnected } = useNotificationChannel(userId, (notification) => {
    console.log('🔔 New notification:', notification);
    
    setNotifications(prev => [notification, ...prev]);
    setUnreadCount(prev => prev + 1);
    
    // Call external handler if provided
    onNotificationReceived?.(notification);
    
    // Show browser notification if permission granted
    if (Notification.permission === 'granted') {
      new Notification(notification.title, {
        body: notification.message,
        icon: '/favicon.ico' // or your app icon
      });
    }
  });

  // Request notification permission on mount
  useEffect(() => {
    if (Notification.permission === 'default') {
      Notification.requestPermission();
    }
  }, []);

  const markAsRead = (notificationId: string) => {
    setNotifications(prev => 
      prev.map(notif => 
        notif.id === notificationId 
          ? { ...notif, read: true }
          : notif
      )
    );
    setUnreadCount(prev => Math.max(0, prev - 1));
  };

  const markAllAsRead = () => {
    setNotifications(prev => 
      prev.map(notif => ({ ...notif, read: true }))
    );
    setUnreadCount(0);
  };

  return (
    <Card
      title={
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
            <Badge count={unreadCount} size="small">
              <BellOutlined />
            </Badge>
            <Text>Live Notifications</Text>
            {!isConnected && <Text type="secondary">(Disconnected)</Text>}
          </div>
          {unreadCount > 0 && (
            <Button 
              size="small" 
              icon={<CheckOutlined />}
              onClick={markAllAsRead}
            >
              Mark all read
            </Button>
          )}
        </div>
      }
      size="small"
    >
      <List
        dataSource={notifications.slice(0, 10)} // Show latest 10
        renderItem={(notification) => (
          <List.Item 
            key={notification.id}
            style={{ 
              backgroundColor: notification.read ? 'transparent' : '#f6f8ff',
              padding: '12px',
              borderRadius: '6px',
              marginBottom: '4px'
            }}
            actions={[
              !notification.read && (
                <Button 
                  size="small" 
                  type="link"
                  onClick={() => markAsRead(notification.id)}
                >
                  Mark read
                </Button>
              )
            ].filter(Boolean)}
          >
            <List.Item.Meta
              title={
                <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                  <Text strong={!notification.read}>{notification.title}</Text>
                  {!notification.read && <Badge status="processing" />}
                </div>
              }
              description={
                <div>
                  <Text>{notification.message}</Text>
                  <br />
                  <Text type="secondary" style={{ fontSize: '12px' }}>
                    {new Date(notification.createdAt).toLocaleString()}
                  </Text>
                </div>
              }
            />
          </List.Item>
        )}
        locale={{ emptyText: 'No notifications' }}
      />
    </Card>
  );
}