# frozen_string_literal: true

module Mutations
  module Model
    class SuperUserUpdate < Mutations::CreateUpdateMutation
      def ready?(**kwargs)
        spoof = kwargs[:spoof]

        if spoof
          return [false, { errors: ['You are not authorized to spoof'] }] unless user_context.super?

          return [false, { errors: ['You cannot spoof yourself.'] }] if spoof == current_user
        end

        true
      end

      setup_mutation Types::Model::UserType, required: false

      model_argument :spoof, Types::Model::UserType, required: false

      def run(**kwargs)
        spoof = kwargs[:spoof]

        user_context = context[:user_context]

        real_user = user_context.real_user

        if spoof
          SuperUser.create_or_update_by!(
            { user: real_user }, update: { spoof_user: spoof }
          )
        else
          user_context.super_user.update!(spoof_user: nil)
        end

        {
          field_name => kwargs[:spoof] || current_user,
          errors: []
        }
      end
    end
  end
end
