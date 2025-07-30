# frozen_string_literal: true

module Types
  class SubscriptionType < Types::BaseObject
    field :message_added, Types::MessageType, null: true,
          description: "A message was added to a chat room" do
      argument :room_id, String, required: true
    end

    field :notifications_updated, Types::NotificationType, null: true,
          description: "User received a new notification or notification count changed"

    def message_added(room_id:)
      # The object here is the message passed from the trigger
      message = object
      Rails.logger.info "🔔 Subscription resolver - message: #{message&.id}, room_id: #{message&.room_id}, requested_room: #{room_id}"
      Rails.logger.info "🔍 Message object class: #{message.class}, inspect: #{message.inspect}"
      
      # Only return the message if it matches the requested room
      return nil unless message
      return nil unless message.room_id == room_id
      
      Rails.logger.info "✅ Message matches room, returning: #{message.id}"
      Rails.logger.info "🔍 Message attributes: id=#{message.id}, content=#{message.content}, user_id=#{message.user_id}"
      
      # Ensure user is loaded
      begin
        user = message.user
        Rails.logger.info "🔍 Message user: #{user.inspect}"
      rescue => e
        Rails.logger.error "❌ Failed to load user: #{e.message}"
      end
      
      message
    end

    def notifications_updated
      # This will be triggered when a new notification is created
      # or when notification count changes
      object
    end
  end
end