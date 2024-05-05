# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::Internal::Auth::SessionsController, type: :request do
  let(:password) { 'rubyruby' }

  let(:user) do
    create(:user, password:, password_confirmation: password)
  end

  def password_base64(otp: nil)
    hash = {
      password:,
      otp:
    }

    Base64.strict_encode64(hash.to_json)
  end

  describe 'update' do
    it 'name' do
      name = Faker::Name.unique.name
      put '/api/internal/auth', params: { name: }, headers: devise_token_auth_headers(user)

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:ok)

      expect(response.headers['uid']).to eq(user.email)
      expect(response.headers['client']).to be_truthy
      expect(response.headers['access-token']).to be_truthy

      user.reload

      expect(user.name).to eq(name)
    end
  end

  describe 'cors' do
    it 'headers' do
      get '/api/internal/auth/validate_token',
          headers: devise_token_auth_headers(user,
                                             additional_headers: { HTTP_ORIGIN: '*',
                                                                   'HTTP_ACCESS_CONTROL_REQUEST_METHOD' => 'GET' })

      expect(response.headers['Access-Control-Allow-Origin']).to eq('*')
      expect(response.headers['Access-Control-Allow-Methods']).to eq('*')

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'without otp' do
    it 'sign_in with password' do
      post '/api/internal/auth/sign_in', params: { email: user.email, password: }
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:ok)
    end

    it 'confirm on sign in' do
      user.update!(confirm_on_sign_in: true)

      expect(user.confirmed?).to be(false)

      post '/api/internal/auth/sign_in', params: { email: user.email, password: }

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:ok)

      user.reload

      expect(user.confirmed?).to be(true)
      expect(user.confirm_on_sign_in).to be(false)
    end

    it 'headers' do
      post '/api/internal/auth/sign_in', params: { email: user.email, password: }

      user_resp = json_response
      expect(response.headers['uid']).to eq(user.email)
      expect(response.headers['client']).to be_truthy
      expect(response.headers['access-token']).to be_truthy

      expect(user_resp[:data]).to include(:id, :email, :name)
    end

    it 'sign in with json' do
      post '/api/internal/auth/sign_in', params: { email: user.email, password: password_base64 }

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'with otp' do
    let(:otp_secret) { ROTP::Base32.random_base32 }

    before do
      user.update!(otp_secret:)

      user.reload
    end

    it 'without otp - plain' do
      post '/api/internal/auth/sign_in', params: { email: user.email, password: }

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:unauthorized)
    end

    it 'without otp - json' do
      post '/api/internal/auth/sign_in', params: { email: user.email, password: password_base64 }

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:unauthorized)
    end

    it 'sign in via api' do
      otp = ROTP::TOTP.new(user.otp_secret).now

      post '/api/internal/auth/sign_in', params: { email: user.email, password: password_base64(otp:) }

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:ok)
    end
  end
end
