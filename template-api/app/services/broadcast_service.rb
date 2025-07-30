# frozen_string_literal: true

class BroadcastService
  class << self
    # Chat broadcasting
    def broadcast_message(room_id, message)
      Rails.logger.info "📡 Broadcasting chat message to room: #{room_id}"
      
      message_data = serialize_message(message)
      
      ActionCable.server.broadcast("chat_#{room_id}", {
        type: 'message_added',
        message: message_data
      })
    end

    def broadcast_typing(room_id, user, is_typing: true)
      Rails.logger.info "📡 Broadcasting typing indicator: #{user.name} #{is_typing ? 'started' : 'stopped'} typing in #{room_id}"
      
      ActionCable.server.broadcast("chat_#{room_id}", {
        type: 'typing_update',
        user: serialize_user(user),
        is_typing: is_typing
      })
    end

    # Presence broadcasting
    def broadcast_user_joined(room_id, user)
      Rails.logger.info "📡 Broadcasting user joined: #{user.name} joined #{room_id}"
      
      ActionCable.server.broadcast("presence_#{room_id}", {
        type: 'user_joined',
        user: serialize_user(user)
      })
    end

    def broadcast_user_left(room_id, user)
      Rails.logger.info "📡 Broadcasting user left: #{user.name} left #{room_id}"
      
      ActionCable.server.broadcast("presence_#{room_id}", {
        type: 'user_left',
        user: serialize_user(user)
      })
    end

    def broadcast_presence_update(room_id, online_users)
      Rails.logger.info "📡 Broadcasting presence update for room: #{room_id} (#{online_users.count} users)"
      
      ActionCable.server.broadcast("presence_#{room_id}", {
        type: 'presence_update',
        users: online_users.map { |user| serialize_user(user) }
      })
    end

    # Notification broadcasting
    def broadcast_notification(user_id, notification)
      Rails.logger.info "📡 Broadcasting notification to user: #{user_id}"
      
      # ActionCable broadcast for direct notifications
      ActionCable.server.broadcast("notifications_#{user_id}", {
        type: 'notification',
        notification: serialize_notification(notification)
      })
      
      # GraphQL subscription trigger
      TemplateApiSchema.subscriptions.trigger('notifications_updated', {}, notification)
    end

    def broadcast_notification_count_update(user_id, unread_count)
      Rails.logger.info "📡 Broadcasting notification count update to user: #{user_id} (#{unread_count} unread)"
      
      ActionCable.server.broadcast("notifications_#{user_id}", {
        type: 'unread_count_update',
        unread_count: unread_count
      })
    end

    # Helper to create and broadcast notification
    def create_and_broadcast_notification(user, title, message, notification_type = 'system', data = {})
      notification = user.notifications.create!(
        title: title,
        message: message,
        notification_type: notification_type,
        data: data
      )
      
      broadcast_notification(user.id, notification)
      notification
    end

    # Live updates broadcasting
    def broadcast_live_update(channel, data)
      Rails.logger.info "📡 Broadcasting live update to: #{channel}"
      
      ActionCable.server.broadcast(channel, {
        type: 'live_update',
        data: data,
        timestamp: Time.current.iso8601
      })
    end

    # System broadcasts
    def broadcast_system_message(room_id, message, level: 'info')
      Rails.logger.info "📡 Broadcasting system message to room: #{room_id}"
      
      ActionCable.server.broadcast("chat_#{room_id}", {
        type: 'system_message',
        message: message,
        level: level,
        timestamp: Time.current.iso8601
      })
    end

    # Document collaboration
    def broadcast_document_change(document_id, change, user)
      Rails.logger.info "📡 Broadcasting document change: #{document_id}"
      
      ActionCable.server.broadcast("document_#{document_id}", {
        type: 'document_change',
        change: change,
        user: serialize_user(user),
        timestamp: Time.current.iso8601
      })
    end

    def broadcast_cursor_position(document_id, user, position)
      ActionCable.server.broadcast("document_#{document_id}", {
        type: 'cursor_update',
        user: serialize_user(user),
        position: position
      })
    end

    private

    def serialize_message(message)
      {
        id: message.id.to_s,
        content: message.content,
        createdAt: message.created_at.iso8601,
        user: serialize_user(message.user)
      }
    end

    def serialize_user(user)
      {
        id: user.id.to_s,
        name: user.name,
        email: user.email,
        avatar: user.avatar&.url # if you have avatars
      }
    end

    def serialize_notification(notification)
      {
        id: notification.id.to_s,
        title: notification.title,
        message: notification.message,
        type: notification.notification_type,
        read: notification.read?,
        createdAt: notification.created_at.iso8601
      }
    end
  end
end