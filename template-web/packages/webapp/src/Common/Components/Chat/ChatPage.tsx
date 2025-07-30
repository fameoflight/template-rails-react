import React from 'react';
import { Row, Col, Space } from 'antd';
import ChatRoom from './ChatRoom';
import OnlineUsers from './OnlineUsers';

interface ChatPageProps {
  roomId: string;
  currentUser?: {
    id: string;
    name: string;
  };
}

export default function ChatPage({ roomId, currentUser }: ChatPageProps) {
  return (
    <Row gutter={16} style={{ height: '100vh', padding: '16px' }}>
      {/* Main chat area */}
      <Col span={18}>
        <ChatRoom roomId={roomId} currentUser={currentUser} />
      </Col>
      
      {/* Sidebar with online users */}
      <Col span={6}>
        <Space direction="vertical" style={{ width: '100%' }}>
          <OnlineUsers roomId={roomId} />
          
          {/* Could add more features here */}
          {/* <TypingIndicators roomId={roomId} /> */}
          {/* <RoomSettings roomId={roomId} /> */}
        </Space>
      </Col>
    </Row>
  );
}