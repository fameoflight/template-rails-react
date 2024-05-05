# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::Health', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get '/api/health'
      expect(response).to have_http_status(:success)
    end
  end
end
