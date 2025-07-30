# frozen_string_literal: true

class NotificationChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.info "🔔 User #{current_user.name} subscribed to notifications"
    stream_from "notifications_#{current_user.id}"
  end

  def unsubscribed
    Rails.logger.info "🔔 User #{current_user.name} unsubscribed from notifications"
  end

  def mark_as_read(data)
    notification_id = data['notification_id']
    Rails.logger.info "📖 Marking notification #{notification_id} as read for user #{current_user.id}"
    
    notification = current_user.notifications.find_by(id: notification_id)
    if notification
      notification.update(read_at: Time.current)
      
      # Broadcast updated unread count
      unread_count = current_user.notifications.unread.count
      BroadcastService.broadcast_notification_count_update(current_user.id, unread_count)
    end
  end

  def mark_all_as_read(data)
    Rails.logger.info "📖 Marking all notifications as read for user #{current_user.id}"
    
    current_user.notifications.unread.update_all(read_at: Time.current)
    BroadcastService.broadcast_notification_count_update(current_user.id, 0)
  end
end