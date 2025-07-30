# frozen_string_literal: true

module Types
  class MessageType < Types::BaseObject
    field :id, ID, null: false
    field :content, String, null: false
    field :user, Types::Model::UserType, null: false
    field :room_id, ID, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    
    def id
      Rails.logger.info "🔍 MessageType#id called for message: #{object.id}"
      object.id.to_s
    end
    
    def user
      Rails.logger.info "🔍 MessageType#user called for message: #{object.id}"
      object.user
    end
  end
end