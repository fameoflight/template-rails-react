# frozen_string_literal: true

module Mutations
  class MessageCreate < GraphQL::Schema::Mutation
    argument :content, String, required: true
    argument :room_id, String, required: true

    field :message, Types::MessageType, null: true
    field :errors, [String], null: false

    def resolve(content:, room_id:)
      Rails.logger.info "🚀 MessageCreate called with content: '#{content}', room_id: '#{room_id}'"
      current_user = context[:current_user] || context[:user_context]&.current_user
      Rails.logger.info "👤 Current user in mutation: #{current_user&.id}"

      if current_user.nil?
        Rails.logger.warn "❌ No authenticated user found in message create mutation"
        return {
          message: nil,
          errors: ['You must be signed in to send messages']
        }
      end

      message = Message.new(
        content: content,
        room_id: room_id,
        user: current_user
      )

      if message.save
        Rails.logger.info "Message saved: #{message.inspect}"
        
        # Reload the message with associations to ensure proper serialization
        message = Message.includes(:user).find(message.id)
        Rails.logger.info "Message reloaded with user: #{message.user&.name} (ID: #{message.user&.id})"
        
        # Broadcast message via ActionCable using the service
        BroadcastService.broadcast_message(room_id, message)

        {
          message: message,
          errors: []
        }
      else
        {
          message: nil,
          errors: message.errors.full_messages
        }
      end
    end
  end
end