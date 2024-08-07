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
  end
end
