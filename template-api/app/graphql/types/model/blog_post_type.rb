# frozen_string_literal: true

module Types
  module Model
    class BlogPostStatusEnum < Types::BaseEnum
      value 'draft'
      value 'published'
    end

    class BlogPostType < Types::BaseModelObject
      setup BlogPost, fields: %i[short_id title published_at tags]

      field :status, BlogPostStatusEnum, null: false

      field :rich_text_content, Types::Store::RichTextJsonType, null: false

      field :comments, [Types::Model::CommentType], null: false
    end
  end
end
