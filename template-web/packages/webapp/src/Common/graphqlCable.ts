import { createConsumer } from '@rails/actioncable';
import jTokerAuthProvider from '@picasso/shared/src/api/jTokerAuthProvider';

interface GraphQLSubscription {
  subscriptionId: string;
  onNext: (data: any) => void;
  onError?: (error: any) => void;
  onComplete?: () => void;
}

class GraphQLActionCableClient {
  private consumer: any = null;
  private subscriptions: Map<string, GraphQLSubscription> = new Map();

  private setupConsumer() {
    if (this.consumer) return; // Already initialized

    const wsUrl = process.env.NODE_ENV === 'production' 
      ? 'wss://api.usepicasso.com/cable'
      : 'ws://localhost:5001/cable';

    try {
      // Get auth headers from the auth provider
      const authHeaders = jTokerAuthProvider.getAuthHeaders();
      console.log('🔑 Auth headers for ActionCable:', authHeaders);
      
      if (authHeaders && authHeaders['access-token']) {
        const params = new URLSearchParams({
          'access-token': authHeaders['access-token'] || '',
          'client': authHeaders['client'] || '',
          'uid': authHeaders['uid'] || ''
        });
        
        const finalUrl = `${wsUrl}?${params.toString()}`;
        console.log('🌐 Connecting to ActionCable with auth:', finalUrl);
        this.consumer = createConsumer(finalUrl);
      } else {
        console.warn('⚠️ No auth headers found, connecting without authentication');
        this.consumer = createConsumer(wsUrl);
      }
    } catch (error) {
      console.warn('❌ jToker error, creating consumer without auth:', error);
      this.consumer = createConsumer(wsUrl);
    }
  }

  subscribe(query: string, variables: any = {}, operationName?: string): Promise<GraphQLSubscription> {
    return new Promise((resolve, reject) => {
      // Ensure consumer is set up before subscribing
      this.setupConsumer();
      
      const subscriptionId = Math.random().toString(36).substr(2, 9);
      
      const subscription: GraphQLSubscription = {
        subscriptionId,
        onNext: () => {},
        onError: reject,
        onComplete: () => {}
      };

      const channel = this.consumer.subscriptions.create('GraphqlChannel', {
        connected: () => {
          console.log('✅ Connected to GraphQL ActionCable');
          console.log('Executing subscription with variables:', variables);
          
          channel.perform('execute', {
            query,
            variables,
            operationName,
            subscriptionId
          });
        },
        
        disconnected: () => {
          console.log('❌ Disconnected from GraphQL ActionCable');
          this.subscriptions.delete(subscriptionId);
        },
        
        rejected: () => {
          console.error('🚫 ActionCable connection rejected - check authentication');
          subscription.onError?.('Connection rejected');
        },
        
        received: (data: any) => {
          console.log('🔔 ActionCable received raw data:', JSON.stringify(data, null, 2));
          if (data.result?.errors) {
            console.error('❌ GraphQL subscription errors:', data.result.errors);
            subscription.onError?.(data.result.errors);
          } else if (data.result?.data) {
            console.log('✅ GraphQL subscription data:', JSON.stringify(data.result.data, null, 2));
            console.log('🎯 Calling onNext with data:', data.result.data);
            subscription.onNext(data.result.data);
          } else {
            console.warn('⚠️ Received data without result.data:', JSON.stringify(data, null, 2));
          }
          
          if (!data.more) {
            console.log('🏁 Subscription complete, calling onComplete');
            subscription.onComplete?.();
          }
        }
      });

      subscription.onComplete = () => {
        channel.unsubscribe();
        this.subscriptions.delete(subscriptionId);
      };

      this.subscriptions.set(subscriptionId, subscription);
      resolve(subscription);
    });
  }

  unsubscribe(subscriptionId: string) {
    const subscription = this.subscriptions.get(subscriptionId);
    if (subscription) {
      subscription.onComplete?.();
    }
  }

  disconnect() {
    if (this.consumer) {
      this.consumer.disconnect();
      this.consumer = null;
    }
    this.subscriptions.clear();
  }
}

export const graphqlCableClient = new GraphQLActionCableClient();
export type { GraphQLSubscription };