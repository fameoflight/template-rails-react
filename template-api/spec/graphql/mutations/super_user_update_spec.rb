# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Model::SuperUserUpdate, type: :graphql do
  def execute(logged_user, spoof_user)
    variables = {
      input: {
        spoofId: graphql_id(spoof_user, Types::Model::UserType)
      }
    }

    query = 'user { id, modelId } errors'

    graphql_execute_mutation('superUserUpdate', variables:, query:, user: logged_user)
  end

  it 'without user' do
    resp = execute(nil, create(:user))

    expect(resp[:object]['errors'][0]).to eq('You are not authorized to spoof')
  end

  it 'user profile' do
    resp = execute(create(:user), create(:user))

    expect(resp[:object]['errors'][0]).to eq('You are not authorized to spoof')
  end

  describe 'super user profile' do
    let(:super_user) { create(:user, email: 'fameoflight@gmail.com') }

    it 'himself' do
      resp = execute(super_user, super_user)

      expect(resp[:object]['errors'][0]).to eq('You cannot spoof yourself.')
    end

    it 'other user' do
      user = create(:user)

      resp = execute(super_user, user)

      expect(resp[:object]['user']['modelId']).to eq(user.id)
    end
  end
end
