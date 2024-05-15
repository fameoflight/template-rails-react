# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DeviseTokenAuth::PasswordsController', type: :request do
  describe 'reset password token' do
    it 'basic' do
      user = create(:user)

      expect(user.reset_password_token).to be_nil

      post '/api/internal/auth/password', params: { email: user.email }

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:ok)

      user.reload

      expect(user.reset_password_token).to be_truthy

      expect(enqueued_jobs).to includes_job(%w[AuthMailer reset_password_instructions])
    end
  end

  describe 'reset password' do
    it 'basic' do
      user = create(:user)
      token = user.send_reset_password_instructions

      expect(token).to be_truthy

      expect(user.reset_password_token).to be_truthy

      params = {
        reset_password_token: token,
        password: 'rubyruby',
        password_confirmation: 'rubyruby'
      }

      put '/api/internal/auth/password', params: params

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:ok)

      expect(response.headers['uid']).to eq(user.email)

      user.reload

      expect(user.reset_password_token).to be_nil
    end
  end
end
