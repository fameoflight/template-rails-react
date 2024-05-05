# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Types::Model::ApiAccessTokenType, type: %i[graphql request] do
  let(:query_string) do
    <<-GRAPHQL
      query($id: ID!){
        node(id: $id) {
          ... on ApiAccessToken {
            id
            name
            modelId
            description
            token
            active
            expiresAt
            user {
              id
              name
            }
          }
        }
      }
    GRAPHQL
  end

  def execute_query(access_token)
    variables = { id: graphql_id(access_token, Types::Model::ApiAccessTokenType) }

    query_result = graphql_execute(query_string, variables:, logging: true, user: access_token.user)
    query_result['data']['node']
  end

  it 'basic' do
    access_token = create(:api_access_token)

    node = execute_query(access_token)

    expect(node['modelId']).to eq(access_token.id)
    expect(node['name']).to eq(access_token.name)
    expect(node['description']).to eq(access_token.description)
  end
end
