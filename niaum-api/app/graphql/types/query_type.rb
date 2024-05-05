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
  end
end
