# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Model::CommentCreateUpdate, type: :graphql do
  def execute_query(input, user)
    variables = { input: }

    query = 'comment { id, richTextContent { content, format } } errors'

    graphql_execute_mutation('commentCreateUpdate', variables:, query:, user:, logging: true)
  end

  it 'create' do
    user = create(:user)

    blog_post = create(:blog_post)

    input = {
      commentableId: graphql_id(blog_post, Types::Model::BlogPostType),
      tags: [],
      rating: 5,
      richTextContent: { content: '{}', format: 'plain' }
    }

    resp = execute_query(input, user)

    expect(resp[:object]['errors']).to eq([])

    comment = Comment.last

    expect(comment.rich_text_content[:content]).to eq('{}')

    expect(comment.user).to eq(user)

    expect(comment.commentable).to eq(blog_post)
  end
end
