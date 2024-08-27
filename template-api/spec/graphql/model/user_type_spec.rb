# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Types::Model::UserType, type: %i[graphql request] do
  let(:query_string) do
    <<-GRAPHQL
      query($id: ID!){
        node(id: $id) {
          ... on User {
            id
            name
            modelId
            cannyToken
            avatar {
              url
            }
          }
        }
      }
    GRAPHQL
  end

  def execute_query(user)
    variables = { id: graphql_id(user, Types::Model::UserType) }

    query_result = graphql_execute(query_string, user:, variables:, logging: true)

    pp query_result if query_result['errors']
    query_result['data']['node']
  end

  it 'basic' do
    user = create(:user)

    node = execute_query(user)

    expect(node['modelId']).to eq(user.id)
    expect(node['name']).to eq(user.name)
    expect(node['avatar']['url']).to be_nil
  end

  describe 'avatar' do
    set(:user) do
      img_avatar = fixture_file_upload('img_avatar.png')
      create(:user, avatar: img_avatar)
    end

    it 'with avatar' do
      node = execute_query(user)

      expect(node['modelId']).to eq(user.id)
      expect(node['name']).to eq(user.name)
      expect(node['avatar']['url']).to include('http://localhost:3000/rails/active_storage/blobs/proxy')
    end

    it 'get image' do
      # this is just to make sure active storage is working as expected

      node = execute_query(user)

      get(node['avatar']['url'])

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('image/png')
      expect(response.headers['Content-Type']).to eq('image/png')
    end
  end
end
