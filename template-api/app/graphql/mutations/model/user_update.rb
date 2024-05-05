# frozen_string_literal: true

module Mutations
  module Model
    class UserUpdate < Mutations::CreateUpdateMutation
      def ready?(**kwargs)
        object = kwargs[:object]

        return true if user_context.current_user == object

        [false, { errors: ["You don't have permission to update this user"] }]
      end

      setup_mutation Types::Model::UserType, arguments: %i[name nickname], required: true

      attachment_argument :avatar, required: false

      argument :send_confirmation_instructions, Boolean, required: false

      def update(object, **kwargs)
        send_confirmation_instructions = kwargs.delete(:send_confirmation_instructions)

        object.send_confirmation_instructions if send_confirmation_instructions

        super(object, **kwargs)
      end
    end
  end
end
