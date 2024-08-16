# frozen_string_literal: true

module Api
  module Public
    class ApiController < ActionController::API
      include ErrorHandler
      include ActionController::HttpAuthentication::Token::ControllerMethods

      before_action :authenticate

      attr_reader :current_user

      private

      def authenticate
        authenticate_user_with_token || handle_bad_authentication
      end

      def authenticate_user_with_token
        authenticate_with_http_token do |token, _options|
          @api_access_token = ApiAccessToken.find_by(token:)

          return false unless @api_access_token&.active?

          @current_user = @api_access_token.user
        end
      end

      def handle_bad_authentication
        raise_error(status: 401, message: 'Bad credentials')
      end
    end
  end
end
