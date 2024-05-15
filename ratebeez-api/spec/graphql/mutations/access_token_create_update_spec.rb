# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Model::ApiAccessTokenCreateUpdate, type: :graphql do
  def execute_query(input, user)
    variables = { input: }

    query = 'apiAccessToken { id } errors'

    graphql_execute_mutation('apiAccessTokenCreateUpdate', variables:, query:, user:, logging: true)
  end

  it 'create' do
    user = create(:user)

    input = {
      name: 'Test',
      active: true
    }

    resp = execute_query(input, user)

    expect(resp[:object]['errors']).to eq([])

    access_token = ApiAccessToken.last

    expect(access_token.name).to eq('Test')

    expect(access_token.user).to eq(user)
  end

  it 'update' do
    user = create(:user)

    access_token = create(:api_access_token, user:)

    input = {
      objectId: graphql_id(access_token, Types::Model::ApiAccessTokenType),
      name: 'Test 2',
      active: false
    }

    resp = execute_query(input, user)

    expect(resp[:object]['errors']).to eq([])

    access_token.reload

    expect(access_token.name).to eq('Test 2')
  end
end
