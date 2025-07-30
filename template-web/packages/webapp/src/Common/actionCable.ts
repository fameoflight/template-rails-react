import { createConsumer } from '@rails/actioncable';
import jTokerAuthProvider from '@picasso/shared/src/api/jTokerAuthProvider';

interface ChannelSubscription {
  channel: string;
  params?: Record<string, any>;
  onConnected?: () => void;
  onDisconnected?: () => void;
  onReceived?: (data: any) => void;
  onRejected?: () => void;
}

interface ActiveSubscription {
  unsubscribe: () => void;
  perform: (action: string, data?: any) => void;
}

class ActionCableManager {
  private consumer: any = null;
  private subscriptions: Map<string, ActiveSubscription> = new Map();

  private setupConsumer() {
    if (this.consumer) return;

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
        console.log('🔌 ActionCable connecting with auth:', finalUrl);
        this.consumer = createConsumer(finalUrl);
      } else {
        console.warn('⚠️ No auth headers found, connecting without authentication');
        this.consumer = createConsumer(wsUrl);
      }
    } catch (error) {
      console.warn('❌ Auth error, creating consumer without auth:', error);
      this.consumer = createConsumer(wsUrl);
    }
  }

  subscribe(config: ChannelSubscription): string {
    this.setupConsumer();
    
    const subscriptionId = `${config.channel}_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
    
    console.log(`🎯 Subscribing to ${config.channel}:`, config.params);
    
    const channelConfig = { 
      channel: config.channel, 
      ...config.params 
    };
    
    const subscription = this.consumer.subscriptions.create(
      channelConfig,
      {
        connected: () => {
          console.log(`✅ Connected to ${config.channel}`);
          config.onConnected?.();
        },
        
        disconnected: () => {
          console.log(`❌ Disconnected from ${config.channel}`);
          this.subscriptions.delete(subscriptionId);
          config.onDisconnected?.();
        },
        
        rejected: () => {
          console.error(`🚫 Connection rejected for ${config.channel}`);
          this.subscriptions.delete(subscriptionId);
          config.onRejected?.();
        },
        
        received: (data: any) => {
          console.log(`📨 ${config.channel} received:`, data);
          config.onReceived?.(data);
        }
      }
    );

    const activeSubscription: ActiveSubscription = {
      unsubscribe: () => {
        subscription.unsubscribe();
        this.subscriptions.delete(subscriptionId);
      },
      perform: (action: string, data?: any) => {
        subscription.perform(action, data);
      }
    };

    this.subscriptions.set(subscriptionId, activeSubscription);
    return subscriptionId;
  }

  unsubscribe(subscriptionId: string) {
    const subscription = this.subscriptions.get(subscriptionId);
    if (subscription) {
      subscription.unsubscribe();
    } else {
      console.warn(`⚠️ Subscription ${subscriptionId} not found`);
    }
  }

  perform(subscriptionId: string, action: string, data?: any) {
    const subscription = this.subscriptions.get(subscriptionId);
    if (subscription) {
      subscription.perform(action, data);
    } else {
      console.warn(`⚠️ Subscription ${subscriptionId} not found`);
    }
  }

  disconnect() {
    console.log('🔌 Disconnecting ActionCable consumer');
    this.subscriptions.forEach(sub => sub.unsubscribe());
    this.subscriptions.clear();
    
    if (this.consumer) {
      this.consumer.disconnect();
      this.consumer = null;
    }
  }

  // Helper method for broadcasting (server-side usage pattern)
  static broadcast(channel: string, data: any) {
    // This would be used on the server side
    // ActionCable.server.broadcast(channel, data)
    console.log(`📡 Broadcasting to ${channel}:`, data);
  }
}

// Export singleton instance
export const actionCable = new ActionCableManager();

// Export types for use in components
export type { ChannelSubscription, ActiveSubscription };
export default actionCable;