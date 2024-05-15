# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::Public::V1::MeController, type: :request do
  describe 'GET /me' do
    it 'returns http success' do
      api_access_token = create(:api_access_token)

      api_access_token.user.reload

      get '/api/public/v1/me', headers: api_token_headers(api_access_token.token)

      expect(response).to have_http_status(:success)

      expect(json_response).to eq(
        id: api_access_token.user.id,
        email: api_access_token.user.email,
        name: api_access_token.user.name,
        uuid: api_access_token.user.uuid
      )
    end
  end

  describe 'authentication' do
    it 'returns http unauthorized' do
      get '/api/public/v1/me'

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns http unauthorized with invalid token' do
      get '/api/public/v1/me', headers: api_token_headers('invalid_token')

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns http unauthorized with expired token' do
      api_access_token = create(:api_access_token, expires_at: 1.day.ago)

      get '/api/public/v1/me', headers: api_token_headers(api_access_token.token)

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns http unauthorized with discarded token' do
      api_access_token = create(:api_access_token)

      api_access_token.discard

      get '/api/public/v1/me', headers: api_token_headers(api_access_token.token)

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
