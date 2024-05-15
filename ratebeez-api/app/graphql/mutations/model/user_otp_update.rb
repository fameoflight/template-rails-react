# frozen_string_literal: true

module Mutations
  module Model
    class UserOtpUpdate < Mutations::CreateUpdateMutation
      DRIFT_BEHIND = 60
      DRIFT_AHEAD = 60

      def ready?(**kwargs)
        object = kwargs[:object]

        return true if user_context.current_user == object

        [false, { errors: ["You don't have permission to update this user."] }]
      end

      setup_mutation Types::Model::UserType, required: true

      argument :otp_code1, String, required: true
      argument :otp_code2, String, required: true
      argument :otp_key, String, required: true

      def update(object, **kwargs)
        otp_key = kwargs[:otp_key]&.strip || ''
        otp_code1 = kwargs[:otp_code1].strip
        otp_code2 = kwargs[:otp_code2].strip

        totp = ROTP::TOTP.new(otp_key)

        errors = []

        errors << 'Invalid OTP code 1' unless totp.verify(otp_code1, drift_behind: DRIFT_BEHIND, drift_ahead: DRIFT_AHEAD)
        errors << 'Invalid OTP code 2' unless totp.verify(otp_code2, drift_behind: DRIFT_BEHIND, drift_ahead: DRIFT_AHEAD)

        if otp_key.blank?
          object.otp_secret = nil
          errors = []
        else
          object.otp_secret = otp_key if errors.empty?
        end

        if errors.empty? && object.save
          {
            field_name => object,
            errors: []
          }
        else
          {
            field_name => nil,
            errors:
          }
        end
      end
    end
  end
end
