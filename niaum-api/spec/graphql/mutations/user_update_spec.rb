# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Model::UserUpdate, type: :graphql do
  it 'without user' do
    user = create(:user)

    user_id = graphql_id(user, Types::Model::UserType)

    variables = {
      input: {
        objectId: user_id,
        name: 'Test'
      }
    }

    query = 'user { id } errors'

    resp = graphql_execute_mutation('userUpdate', variables:, query:)

    expect(resp[:object]['errors'][0]).to eq("You don't have permission to update this user")
  end

  it 'other user' do
    user = create(:user)

    user_id = graphql_id(user, Types::Model::UserType)

    variables = {
      input: {
        objectId: user_id,
        name: 'Test'
      }
    }

    query = 'user { id } errors'

    resp = graphql_execute_mutation('userUpdate', variables:, query:, user: create(:user))

    expect(resp[:object]['errors'][0]).to eq("You don't have permission to update this user")

    resp = graphql_execute_mutation('userUpdate', variables:, query:, user:)

    expect(resp[:object]['errors']).to eq([])

    user.reload

    expect(user.name).to eq('Test')
  end

  # it 'with different object id' do
  #   variables = {
  #     input: {
  #       objectId: 'gid://hub/company/1',
  #       name: 'Test'
  #     }
  #   }

  #   query = 'user { id } errors'

  #   resp = graphql_execute_mutation('userUpdate', variables:, query:, user: create(:user), logging: false)

  #   expect(resp[:errors][0]['message']).to include('expected User, got Hub::Company')
  # end
end
