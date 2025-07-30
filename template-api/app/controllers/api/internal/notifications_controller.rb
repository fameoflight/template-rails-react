# frozen_string_literal: true

module Api
  module Internal
    class NotificationsController < ApplicationController
      before_action :verify_signed_in

      def index
        limit = params[:limit]&.to_i || 20
        
        notifications = current_user.notifications
                                   .recent
                                   .limit(limit)

        unread_count = current_user.notifications.unread.count

        render json: {
          notifications: notifications.map { |notification| serialize_notification(notification) },
          unread_count: unread_count
        }
      end

      def mark_as_read
        notification = current_user.notifications.find(params[:id])
        notification.mark_as_read!
        
        unread_count = current_user.notifications.unread.count
        
        render json: {
          success: true,
          unread_count: unread_count
        }
      end

      def mark_all_as_read
        current_user.notifications.unread.update_all(read_at: Time.current)
        
        render json: {
          success: true,
          unread_count: 0
        }
      end

      private

      def serialize_notification(notification)
        {
          id: notification.id.to_s,
          title: notification.title,
          message: notification.message,
          notification_type: notification.notification_type,
          read: notification.read?,
          created_at: notification.created_at.iso8601,
          icon: notification.icon,
          color: notification.color,
          data: notification.data
        }
      end
    end
  end
end