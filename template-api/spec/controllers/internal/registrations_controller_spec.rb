# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::Internal::Auth::RegistrationsController, type: :request do
  describe 'sign up as admin' do
    context 'success' do
      it 'basic' do
        email = Faker::Internet.email
        name = Faker::Name.name

        User.where(email:).destroy_all

        invite_code = ROTP::Base32.random_base32

        post '/api/internal/auth', params: { name:,
                                             email:,
                                             password: 'rubyruby',
                                             inviteCode: invite_code }

        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:ok)

        expect(response.headers['uid']).to eq(email)

        # enqueued confirm email job
        expect(enqueued_jobs).to includes_job(%w[AuthMailer confirmation_instructions])

        user = User.find_by(email:)

        expect(user.invite_code).to eq(invite_code)

        expect(user.name).to eq(name)
      end
    end
  end
end
