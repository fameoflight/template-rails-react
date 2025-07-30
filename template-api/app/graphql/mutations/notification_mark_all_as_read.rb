# frozen_string_literal: true

module Mutations
  class NotificationMarkAllAsRead < BaseMutation
    description "Mark all notifications as read for the current user"

    field :success, Boolean, null: false
    field :unread_count, Integer, null: false
    field :errors, [String], null: false

    def run
      result = current_user.notifications.unread.update_all(read_at: Time.current)
      
      if result
        # Broadcast the count update to all user's connections
        BroadcastService.broadcast_notification_count_update(current_user.id, 0)
        
        {
          success: true,
          unread_count: 0,
          errors: []
        }
      else
        {
          success: false,
          unread_count: current_user.notifications.unread.count,
          errors: ["Failed to mark notifications as read"]
        }
      end
    end
  end
end