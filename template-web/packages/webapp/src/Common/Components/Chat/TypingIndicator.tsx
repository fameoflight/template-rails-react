import React, { useState, useEffect } from 'react';
import { Typography, Space } from 'antd';
import { LoadingOutlined } from '@ant-design/icons';

const { Text } = Typography;

interface User {
  id: string;
  name: string;
}

interface TypingIndicatorProps {
  typingUsers: User[];
  currentUserId?: string;
}

export default function TypingIndicator({ typingUsers, currentUserId }: TypingIndicatorProps) {
  // Filter out current user from typing indicators
  const otherUsersTyping = typingUsers.filter(user => user.id !== currentUserId);

  if (otherUsersTyping.length === 0) {
    return <div style={{ height: '20px' }} />; // Placeholder to prevent layout shift
  }

  const renderTypingText = () => {
    const count = otherUsersTyping.length;
    
    if (count === 1) {
      return `${otherUsersTyping[0].name} is typing...`;
    } else if (count === 2) {
      return `${otherUsersTyping[0].name} and ${otherUsersTyping[1].name} are typing...`;
    } else if (count === 3) {
      return `${otherUsersTyping[0].name}, ${otherUsersTyping[1].name}, and ${otherUsersTyping[2].name} are typing...`;
    } else {
      return `${otherUsersTyping[0].name} and ${count - 1} others are typing...`;
    }
  };

  return (
    <div style={{ 
      height: '20px', 
      display: 'flex', 
      alignItems: 'center',
      paddingLeft: '16px',
      paddingBottom: '8px'
    }}>
      <Space size={8}>
        <LoadingOutlined style={{ fontSize: '12px', color: '#999' }} />
        <Text type="secondary" style={{ fontSize: '12px', fontStyle: 'italic' }}>
          {renderTypingText()}
        </Text>
      </Space>
    </div>
  );
}