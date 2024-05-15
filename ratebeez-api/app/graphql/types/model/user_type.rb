# frozen_string_literal: true

module Types
  module Model
    class UserType < Types::BaseModelObject
      implements Types::ModelAttachmentInterface # TODO: remove this when we have a model that is actually using it, this is just a placeholder

      setup :user, fields: %i[name nickname confirmed_at]

      field :otp_enabled, Boolean, null: false

      field :otp_provisioning_uri, String, null: false

      field :avatar, Types::Model::AttachmentType, null: true

      field :spoof, Boolean, null: false

      field :canny_token, String, null: true

      field :api_access_tokens, [Types::Model::ApiAccessTokenType], null: false

      def otp_provisioning_uri
        issuer = Rails.env.production? ? 'Ratebeez' : "Ratebeez #{Rails.env}"

        totp = ROTP::TOTP.new(ROTP::Base32.random_base32, issuer:)

        totp.provisioning_uri(object.email)
      end

      def otp_enabled
        object.otp_secret.present?
      end

      def spoof
        user_context.spoof?
      end

      def canny_token
        Services::Canny.new(object).get_token
      end

      def api_access_tokens
        ApiAccessToken.where(user: object, discarded_at: nil)
      end
    end
  end
end
