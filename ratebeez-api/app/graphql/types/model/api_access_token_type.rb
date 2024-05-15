# frozen_string_literal: true

module Types
  module Model
    class ApiAccessTokenType < Types::BaseModelObject
      implements Types::CommentInterface

      def self.authorized?(object, context)
        user_context = context[:user_context]

        super && object.user == user_context.current_user
      end

      setup ApiAccessToken, fields: %i[name description token active expires_at]

      field :user, Types::Model::UserType, null: false
    end
  end
end
