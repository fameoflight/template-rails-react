# frozen_string_literal: true

module Mutations
  class NotificationMarkAsRead < BaseMutation
    description "Mark a notification as read"

    argument :notification_id, ID, required: true

    field :notification, Types::NotificationType, null: true
    field :unread_count, Integer, null: false
    field :errors, [String], null: false

    def run(notification_id:)
      notification = current_user.notifications.find_by(id: notification_id)
      
      unless notification
        return {
          notification: nil,
          unread_count: current_user.notifications.unread.count,
          errors: ["Notification not found"]
        }
      end

      if notification.mark_as_read!
        unread_count = current_user.notifications.unread.count
        
        # Broadcast the count update to all user's connections
        BroadcastService.broadcast_notification_count_update(current_user.id, unread_count)
        
        {
          notification: notification,
          unread_count: unread_count,
          errors: []
        }
      else
        {
          notification: nil,
          unread_count: current_user.notifications.unread.count,
          errors: notification.errors.full_messages
        }
      end
    end
  end
end