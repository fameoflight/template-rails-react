# frozen_string_literal: true

module Types
  class NotificationType < Types::BaseModelObject
    setup 'Notification'

    field :title, String, null: false
    field :message, String, null: false
    field :notification_type, String, null: false
    field :read, Boolean, null: false
    field :read_at, GraphQL::Types::ISO8601DateTime, null: true
    field :data, GraphQL::Types::JSON, null: true
    field :icon, String, null: false
    field :color, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    def read
      object.read?
    end

    def icon
      object.icon
    end

    def color
      object.color
    end
  end
end