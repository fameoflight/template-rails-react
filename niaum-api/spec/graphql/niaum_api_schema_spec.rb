# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NiaumApiSchema do
  let(:query) do
    '{ env, currentUser { id, name, modelId } }'
  end

  describe 'basic' do
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
end
