# frozen_string_literal: true

module Mutations
  module Model
    class ApiAccessTokenCreateUpdate < Mutations::CreateUpdateMutation
      def ready?(**kwargs)
        object = kwargs[:object]

        return user_context.current_user == object.user if object

        super
      end

      setup_mutation Types::Model::ApiAccessTokenType, arguments: %i[name description active expires_at]

      def create(**kwargs)
        kwargs[:user] = user_context.current_user

        super
      end
    end
  end
end
