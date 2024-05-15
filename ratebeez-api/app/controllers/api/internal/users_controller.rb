# frozen_string_literal: true

module Api
  module Internal
    # not used currently
    class UsersController < ApplicationController
      before_action :verify_signed_in, only: %i[avatar]

      # POST /avatar
      def avatar
        current_user.avatar = params[:avatar]

        if current_user.save
          render json: current_user, status: :created
        else
          render json: current_user.errors, status: :unprocessable_entity
        end
      end

      def google_login
        access_token = params[:access_token]
        scopes = params[:scope].split
        token_type = params[:token_type]

        raise Api::Exceptions::Base, status: 422, message: "Invalid token type: #{token_type}" if token_type != 'Bearer'

        user = Services::GoogleLogin.new(access_token:, scope: scopes, token_type:).user

        @resource = get_or_create_user(email: user['email'], name: user['name'])

        create_and_assign_token

        sign_in(@resource, scope: :user, store: false, bypass: false)

        render json: {
          data: resource_data(resource_json: @resource.token_validation_response)
        }
      end

      private

      # Below methods copied from DeviseTokenAuth

      def create_and_assign_token
        if @resource.respond_to?(:with_lock)
          @resource.with_lock do
            @token = @resource.create_token
            @resource.save!
          end
        else
          @token = @resource.create_token
          @resource.save!
        end
      end

      def resource_data(opts = {})
        response_data = opts[:resource_json] || @resource.as_json
        response_data['type'] = @resource.class.name.parameterize if json_api?
        response_data
      end

      def get_or_create_user(email:, name:, **_opts)
        user = User.find_by(email:)

        password = SecureRandom.hex(16)

        user || User.create!(email:, name:, password:, password_confirmation: password,
                             confirmed_at: Time.zone.now, provider: 'google_oauth2', uid: email)
      end

      def json_api?
        return false unless defined?(ActiveModel::Serializer)

        if ActiveModel::Serializer.respond_to?(:setup)
          return ActiveModel::Serializer.setup do |config|
            config.adapter == :json_api
          end
        end
        ActiveModelSerializers.config.adapter == :json_api
      end
    end
  end
end
