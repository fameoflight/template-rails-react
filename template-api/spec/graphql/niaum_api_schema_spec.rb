# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TemplateApiSchema do
  describe 'basic' do
    let(:query) do
      '{ env, currentUser { id, name, modelId } }'
    end

    it 'env' do
      result = described_class.execute(query)

      expect(result['data']['env']).to eq(Rails.env)
    end

    it 'no user viewer' do
      query_result = described_class.execute(query)

      expect(query_result['data']['currentUser']).to be_nil
    end

    it 'with user viewer' do
      user = create(:user)

      context = { current_user: user, user_context: UserContext.new(user) }

      query_result = described_class.execute(query, context:)

      expect(query_result['data']['currentUser']['name']).to eq(user.name)

      expect(query_result['data']['currentUser']['modelId']).to eq(user.id)
    end
  end

  describe 'blogPosts' do
    def query(status:)
      <<~GQL
        {
          blogPosts(status: #{status}) {
            id
            publishedAt
            title
          }
        }
      GQL
    end

    it 'no blog posts' do
      query_result = described_class.execute(query(status: :all))

      expect(query_result['data']['blogPosts']).to eq([])
    end

    it 'with blog posts' do
      create(:blog_post, title: 'First Post')

      create(:blog_post, title: 'Second Post')

      query_result = described_class.execute(query(status: :all))

      expect(query_result['data']['blogPosts'].size).to eq(2)

      expect(query_result['data']['blogPosts'].map { |x| x['title'] }).to eq(['First Post', 'Second Post'])
    end

    it 'with status' do
      create(:blog_post, title: 'First Post', status: :published)

      create(:blog_post, title: 'Second Post', status: :draft)

      query_result = described_class.execute(query(status: :published))

      expect(query_result['data']['blogPosts'].size).to eq(1)

      expect(query_result['data']['blogPosts'].first['title']).to eq('First Post')
    end
  end
end
