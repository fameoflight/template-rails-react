import { useEffect, useRef, useCallback } from 'react';
import actionCable, { ChannelSubscription } from '../actionCable';

interface UseActionCableOptions {
  channel: string;
  params?: Record<string, any>;
  onConnected?: () => void;
  onDisconnected?: () => void;
  onReceived?: (data: any) => void;
  onRejected?: () => void;
  // Auto-connect when hook mounts
  autoConnect?: boolean;
  // Dependencies to watch for reconnection
  dependencies?: any[];
}

export function useActionCable(options: UseActionCableOptions) {
  const subscriptionIdRef = useRef<string | null>(null);
  const {
    channel,
    params,
    onConnected,
    onDisconnected,
    onReceived,
    onRejected,
    autoConnect = true,
    dependencies = []
  } = options;

  const connect = useCallback(() => {
    if (subscriptionIdRef.current) {
      console.warn(`⚠️ Already connected to ${channel}`);
      return subscriptionIdRef.current;
    }

    const config: ChannelSubscription = {
      channel,
      params,
      onConnected,
      onDisconnected: () => {
        subscriptionIdRef.current = null;
        onDisconnected?.();
      },
      onReceived,
      onRejected: () => {
        subscriptionIdRef.current = null;
        onRejected?.();
      }
    };

    subscriptionIdRef.current = actionCable.subscribe(config);
    return subscriptionIdRef.current;
  }, [channel, JSON.stringify(params), onConnected, onDisconnected, onReceived, onRejected]);

  const disconnect = useCallback(() => {
    if (subscriptionIdRef.current) {
      actionCable.unsubscribe(subscriptionIdRef.current);
      subscriptionIdRef.current = null;
    }
  }, []);

  const perform = useCallback((action: string, data?: any) => {
    if (subscriptionIdRef.current) {
      actionCable.perform(subscriptionIdRef.current, action, data);
    } else {
      console.warn(`⚠️ Cannot perform action: not connected to ${channel}`);
    }
  }, [channel]);

  // Auto-connect on mount and dependency changes
  useEffect(() => {
    if (autoConnect) {
      connect();
    }

    return () => {
      disconnect();
    };
  }, [autoConnect, ...dependencies]); // Remove connect/disconnect from deps to prevent loops

  return {
    connect,
    disconnect,
    perform,
    isConnected: subscriptionIdRef.current !== null,
    subscriptionId: subscriptionIdRef.current
  };
}

// Specialized hook for chat functionality
export function useChatChannel(
  roomId: string, 
  onMessageReceived: (message: any) => void,
  onTypingUpdate?: (data: { user: any; is_typing: boolean }) => void
) {
  return useActionCable({
    channel: 'ChatChannel',
    params: { room_id: roomId },
    onReceived: (data) => {
      if (data.type === 'message_added' && data.message) {
        onMessageReceived(data.message);
      } else if (data.type === 'typing_update' && onTypingUpdate) {
        onTypingUpdate(data);
      }
    },
    dependencies: [roomId]
  });
}

// Hook for presence/online status
export function usePresenceChannel(roomId: string, onPresenceUpdate: (users: any[]) => void) {
  return useActionCable({
    channel: 'PresenceChannel',
    params: { room_id: roomId },
    onReceived: (data) => {
      if (data.type === 'presence_update') {
        onPresenceUpdate(data.users);
      }
    },
    dependencies: [roomId]
  });
}

// Hook for live notifications
export function useNotificationChannel(userId: string, onNotification: (notification: any) => void) {
  return useActionCable({
    channel: 'NotificationChannel',
    params: { user_id: userId },
    onReceived: (data) => {
      if (data.type === 'notification') {
        onNotification(data.notification);
      }
    },
    dependencies: [userId]
  });
}