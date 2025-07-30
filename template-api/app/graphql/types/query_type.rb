# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField
    include CustomNodeField

    field :env, String, null: false

    field :current_user, Types::Model::UserType, null: true

    field :spoof, Boolean, null: false

    field :super_user, Types::Model::SuperUserType, null: false

    field :blog_posts, [Types::Model::BlogPostType], null: false do
      enum_argument :status, values: %i[all draft published], required: true
    end

    field :blog_post, Types::Model::BlogPostType, null: true do
      argument :short_id, String, required: true
    end

    field :cities, [Types::CityType], null: false do
      argument :country_code, String, required: true
    end

    field :messages, [Types::MessageType], null: false do
      argument :room_id, String, required: true
      argument :limit, Integer, required: false, default_value: 50
    end

    field :notifications, Types::NotificationType.connection_type, null: false do
      argument :limit, Integer, required: false, default_value: 20
    end

    field :unread_notification_count, Integer, null: false

    def env
      Rails.env
    end

    def current_user
      user_context&.current_user
    end

    def spoof
      user_context&.spoof?
    end

    def super_user
      user_context&.current_user
    end

    def blog_posts(status:)
      if status == 'all'
        BlogPost.all
      else
        BlogPost.where(status:)
      end
    end

    def blog_post(short_id:)
      BlogPost.find_by(short_id:)
    end

    def cities(country_code:)
      Services::City.new(country_code).get
    end

    def messages(room_id:, limit:)
      Message.for_room(room_id).recent.limit(limit)
    end

    def notifications(limit:)
      user_context.current_user.notifications.recent.limit(limit)
    end

    def unread_notification_count
      user_context.current_user.notifications.unread.count
    end
  end
end
