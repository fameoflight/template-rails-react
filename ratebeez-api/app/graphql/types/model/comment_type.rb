# frozen_string_literal: true

module Types
  module Model
    class CommentType < Types::BaseModelObject
      setup Comment, fields: %i[discarded_at tags rating]

      field :user, Types::Model::UserType, null: false

      field :rich_text_content, Types::Store::RichTextJsonType, null: false
    end
  end
end
