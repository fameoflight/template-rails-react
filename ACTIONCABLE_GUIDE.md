# ActionCable Abstraction Guide

This guide shows how to use our ActionCable abstraction for real-time features across the application.

## Architecture Overview

### Backend (Rails)
- **Channels**: Handle WebSocket connections (`app/channels/`)
- **BroadcastService**: Centralized broadcasting service (`app/services/broadcast_service.rb`)
- **Authentication**: Automatic user authentication via DeviseTokenAuth

### Frontend (React)
- **ActionCableManager**: Core connection management (`src/Common/actionCable.ts`)
- **Hooks**: React hooks for easy integration (`src/Common/hooks/useActionCable.ts`)
- **Components**: Pre-built components for common features

## Quick Start

### 1. Basic ActionCable Connection

```typescript
import { useActionCable } from '@/Common/hooks/useActionCable';

function MyComponent() {
  const { isConnected, perform } = useActionCable({
    channel: 'MyChannel',
    params: { room_id: 'general' },
    onReceived: (data) => {
      console.log('Received:', data);
    }
  });

  return <div>Status: {isConnected ? 'Connected' : 'Disconnected'}</div>;
}
```

### 2. Chat Implementation

```typescript
import { useChatChannel } from '@/Common/hooks/useActionCable';

function ChatRoom({ roomId }) {
  const [messages, setMessages] = useState([]);
  
  const { isConnected } = useChatChannel(roomId, (message) => {
    setMessages(prev => [...prev, message]);
  });

  return (
    <div>
      {/* Chat UI */}
    </div>
  );
}
```

### 3. Server-side Broadcasting

```ruby
# In any controller, service, or background job
BroadcastService.broadcast_message(room_id, message)
BroadcastService.broadcast_notification(user_id, notification)
BroadcastService.broadcast_live_update(channel, data)
```

## Available Features

### 1. Chat System
- **Channel**: `ChatChannel`
- **Hook**: `useChatChannel(roomId, onMessage)`
- **Component**: `<ChatRoom />`, `<ChatPage />`

```ruby
# Rails
BroadcastService.broadcast_message(room_id, message)
BroadcastService.broadcast_typing(room_id, user, is_typing: true)
```

### 2. Online Presence
- **Channel**: `PresenceChannel`
- **Hook**: `usePresenceChannel(roomId, onPresenceUpdate)`
- **Component**: `<OnlineUsers />`

```ruby
# Rails - handled automatically in PresenceChannel
BroadcastService.broadcast_user_joined(room_id, user)
BroadcastService.broadcast_user_left(room_id, user)
```

### 3. Live Notifications
- **Channel**: `NotificationChannel`
- **Hook**: `useNotificationChannel(userId, onNotification)`
- **Component**: `<LiveNotifications />`

```ruby
# Rails
BroadcastService.broadcast_notification(user_id, notification)
```

## Creating New Features

### 1. Create a Rails Channel

```ruby
# app/channels/my_feature_channel.rb
class MyFeatureChannel < ApplicationCable::Channel
  def subscribed
    stream_from "my_feature_#{params[:id]}"
  end

  def unsubscribed
    # Cleanup logic
  end

  def perform_action(data)
    # Handle client actions
  end
end
```

### 2. Add Broadcasting Methods

```ruby
# In BroadcastService
def self.broadcast_my_feature(id, data)
  Rails.logger.info "📡 Broadcasting my feature: #{id}"
  
  ActionCable.server.broadcast("my_feature_#{id}", {
    type: 'feature_update',
    data: data
  })
end
```

### 3. Create React Hook

```typescript
// In useActionCable.ts
export function useMyFeatureChannel(id: string, onUpdate: (data: any) => void) {
  return useActionCable({
    channel: 'MyFeatureChannel',
    params: { id },
    onReceived: (data) => {
      if (data.type === 'feature_update') {
        onUpdate(data.data);
      }
    },
    dependencies: [id]
  });
}
```

### 4. Use in Components

```typescript
function MyFeatureComponent({ id }: { id: string }) {
  const [featureData, setFeatureData] = useState(null);
  
  const { isConnected } = useMyFeatureChannel(id, (data) => {
    setFeatureData(data);
  });

  return (
    <div>
      Status: {isConnected ? 'Live' : 'Offline'}
      Data: {JSON.stringify(featureData)}
    </div>
  );
}
```

## Feature Ideas

### Implemented ✅
- [x] Chat messaging
- [x] Online presence
- [x] Live notifications

### Possible Features 🚀
- [ ] Typing indicators
- [ ] Message reactions
- [ ] Live document collaboration
- [ ] Real-time cursor tracking
- [ ] Live polls/voting
- [ ] System status updates
- [ ] Live analytics dashboard
- [ ] Video call coordination
- [ ] Screen sharing signals
- [ ] Live form collaboration
- [ ] Real-time gaming
- [ ] Live shopping cart sync
- [ ] Collaborative whiteboard

## Best Practices

### 1. Authentication
- Authentication is handled automatically via `jTokerAuthProvider`
- All channels inherit from `ApplicationCable::Channel` with authentication

### 2. Error Handling
```typescript
const { isConnected, connect, disconnect } = useActionCable({
  channel: 'MyChannel',
  onRejected: () => {
    console.error('Connection rejected - check authentication');
  },
  onDisconnected: () => {
    // Handle disconnection
    setTimeout(connect, 5000); // Retry after 5s
  }
});
```

### 3. Performance
- Use `dependencies` array in hooks to control reconnection
- Implement proper cleanup in `useEffect`
- Consider message throttling for high-frequency updates

### 4. Debugging
```typescript
// Enable detailed logging
console.log('ActionCable status:', { isConnected, subscriptionId });
```

## Redis Configuration

Ensure Redis is configured for ActionCable:

```yaml
# config/cable.yml
development:
  adapter: redis
  url: <%= ENV.fetch("REDIS_URL") { "redis://localhost:6379/1" } %>
```

## Testing

```typescript
// Test connection
const { isConnected } = useActionCable({
  channel: 'TestChannel',
  onConnected: () => console.log('✅ Connected'),
  onDisconnected: () => console.log('❌ Disconnected'),
  onReceived: (data) => console.log('📨 Received:', data)
});
```

## Troubleshooting

### Common Issues
1. **Authentication failures**: Check `jTokerAuthProvider.getAuthHeaders()`
2. **Connection refused**: Verify Rails server and Redis are running
3. **Messages not received**: Check channel names and broadcasting
4. **Memory leaks**: Ensure proper cleanup in `useEffect`

### Debug Commands
```bash
# Check Redis connections
redis-cli monitor

# Check Rails ActionCable
tail -f log/development.log | grep ActionCable
```