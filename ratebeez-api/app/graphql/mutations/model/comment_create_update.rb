# frozen_string_literal: true

module Mutations
  module Model
    class CommentCreateUpdate < Mutations::CreateUpdateMutation
      def ready?(**kwargs)
        object = kwargs[:object]

        if object && object.user != current_user
          return [false, { errors: ["You don't have permission to update this comment"] }]
        end

        super
      end

      setup_mutation Types::Model::CommentType, arguments: %i[tags rating]

      argument :rich_text_content, Types::Store::JsonInputType, required: true

      model_argument :commentable, nil, required: false

      attachment_argument :attachment, required: false

      def create(**kwargs)
        kwargs[:user] = user_context.current_user

        super
      end

    end
  end
end
