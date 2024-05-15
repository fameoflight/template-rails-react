# frozen_string_literal: true

module Helpers
  module ActiveStorage
    def attachment_url(object, host: nil)
      return nil unless object.attached?

      host ||= default_host

      Rails.cache.fetch("active_storage_#{object.id}_url") do
        Rails.application.routes.url_helpers.rails_blob_url(object, host:)
      end
    end

    def service_url(object, expires_in: 1.day)
      return nil unless object.attached?

      Rails.cache.fetch("active_storage_#{object.id}_service_url") do
        object.url(expires_in:)
      end
    end

    def default_host
      host = Rails.application.routes.default_url_options[:host]

      if host.blank?
        Rails.env.development? ? 'http://localhost:5001' : 'https://api.ratebeez.com'
      else
        host
      end
    end
  end
end
