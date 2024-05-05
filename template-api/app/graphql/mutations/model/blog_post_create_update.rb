# frozen_string_literal: true

module Mutations
  module Model
    class BlogPostCreateUpdate < Mutations::CreateUpdateMutation
      def ready?(**kwargs)
        user_context.super_user? && super
      end

      setup_mutation Types::Model::BlogPostType, arguments: %i[short_id title tags]

      argument :rich_text_content, Types::Store::JsonInputType, required: true
    end
  end
end
