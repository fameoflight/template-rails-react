# frozen_string_literal: true

module Types
  module CommentInterface
    include Types::ModelInterface

    field :comments, [Types::Model::CommentType], null: false

    field :comment_count, Int, null: false

    delegate :comments, to: :object

    def comment_count
      object.comments.count
    end
  end
end
