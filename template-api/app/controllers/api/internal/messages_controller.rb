# frozen_string_literal: true

module Api
  module Internal
    class MessagesController < ApplicationController
      before_action :verify_signed_in

      def index
        room_id = params[:room_id]
        limit = params[:limit]&.to_i || 50

        messages = Message.for_room(room_id)
                         .includes(:user)
                         .recent
                         .limit(limit)
                         .order(:created_at) # Order oldest first for display

        render json: {
          messages: messages.map do |message|
            {
              id: message.id.to_s,
              content: message.content,
              createdAt: message.created_at.iso8601,
              user: {
                id: message.user.id.to_s,
                name: message.user.name || 'Anonymous'
              }
            }
          end
        }
      end
    end
  end
end