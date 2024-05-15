# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::Internal::UsersController, type: :request do
  describe 'POST /avatar' do
    it 'returns http success' do
      user = create(:user)
      img_avatar = fixture_file_upload('img_avatar.png')

      post '/api/internal/users/avatar', params: { avatar: img_avatar }, headers: devise_token_auth_headers(user)

      expect(response).to have_http_status(:success)

      user.reload

      expect(user.avatar.attached?).to be(true)
    end

    it 'returns http error on no user' do
      img_avatar = fixture_file_upload('img_avatar.png')

      post '/api/internal/users/avatar', params: { avatar: img_avatar }

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'POST /google_login' do
    let(:google_response) do
      json_fixture('auth/google_login_response.json')
    end

    it 'new user' do
      User.where(email: 'fameoflight@gmail.com').destroy_all

      VCR.use_cassette('google_login') do
        expect do
          post '/api/internal/users/google_login', params: google_response
        end.to change(User, :count).by(1)

        expect(response).to have_http_status(:success)

        expect(response.headers['uid']).to eq('fameoflight@gmail.com')
        expect(response.headers['client']).to be_truthy
        expect(response.headers['access-token']).to be_truthy
      end
    end

    it 'existing user' do
      user = create(:user, email: 'fameoflight@gmail.com')

      VCR.use_cassette('google_login') do
        expect do
          post '/api/internal/users/google_login', params: google_response
        end.not_to change(User, :count)

        expect(response).to have_http_status(:success)

        expect(response.headers['uid']).to eq('fameoflight@gmail.com')

        user.reload
      end
    end
  end
end
