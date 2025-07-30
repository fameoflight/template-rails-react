import React, { useState } from 'react';
import { Card, Avatar, List, Badge, Typography } from 'antd';
import { UserOutlined } from '@ant-design/icons';
import { usePresenceChannel } from '../../hooks/useActionCable';

const { Text } = Typography;

interface User {
  id: string;
  name: string;
  email: string;
  avatar?: string;
}

interface OnlineUsersProps {
  roomId: string;
}

export default function OnlineUsers({ roomId }: OnlineUsersProps) {
  const [onlineUsers, setOnlineUsers] = useState<User[]>([]);

  // Use the presence channel hook
  const { isConnected } = usePresenceChannel(roomId, (users) => {
    console.log('👥 Presence update:', users);
    setOnlineUsers(users);
  });

  return (
    <Card 
      title={
        <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
          <Badge 
            status={isConnected ? 'success' : 'error'} 
            text={`Online Users (${onlineUsers.length})`} 
          />
        </div>
      }
      size="small"
      style={{ marginBottom: 16 }}
    >
      <List
        dataSource={onlineUsers}
        renderItem={(user) => (
          <List.Item key={user.id} style={{ padding: '8px 0' }}>
            <List.Item.Meta
              avatar={
                <Badge dot status="success">
                  <Avatar 
                    src={user.avatar} 
                    icon={<UserOutlined />}
                    size="small"
                  >
                    {user.name?.charAt(0).toUpperCase()}
                  </Avatar>
                </Badge>
              }
              title={<Text strong style={{ fontSize: '14px' }}>{user.name}</Text>}
              description={<Text type="secondary" style={{ fontSize: '12px' }}>Online</Text>}
            />
          </List.Item>
        )}
        locale={{ emptyText: 'No users online' }}
      />
    </Card>
  );
}