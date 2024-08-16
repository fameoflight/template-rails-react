# frozen_string_literal: true

require 'jwt'

module Services
  class Canny
    attr_accessor :user

    def initialize(user)
      @user = user
    end

    def get_token
      return nil if user.nil?

      user_data = {
        id: user.id,
        email: canny_email,
        name: user.name
      }

      JWT.encode(user_data, canny_key, 'HS256')
    end

    private

    def canny_email
      domain = 'canny.usepicasso.com'

      domain = "development.#{domain}" unless Rails.env.production?

      user_id = user.uuid[0..7]

      "#{user_id}@#{domain}"
    end

    def canny_key
      Rails.application.credentials[:api][:production][:canny]
    end
  end
end
