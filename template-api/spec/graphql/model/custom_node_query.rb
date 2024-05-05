# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Types::CustomNodeField, type: %i[graphql request] do
  let(:query_string) do
    <<-GRAPHQL
      query($id: ID!, $name: String!){
        customNode(id: $id, name: $name) {
          ... on User {
            id
            name
          }
        }
      }
    GRAPHQL
  end

  def execute_query(user, graphql_type, graphql_name)
    context = { current_user: user }

    variables = { id: graphql_id(user, graphql_type), name: graphql_name }

    query_result = graphql_execute(query_string, context:, variables:)
    query_result['data']['customNode']
  end

  it 'basic with UserType' do
    user = create(:user)

    node = execute_query(user, Types::Model::UserType, 'User')

    expect(node['name']).to eq(user.name)
  end
end
