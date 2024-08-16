# frozen_string_literal: true

module CorsHelper
  extend ActiveSupport::Concern

  included do
    before_action :cors_preflight_check
    after_action :cors_set_access_control_headers

    # For all responses in this controller, return the CORS access control headers.

    def cors_set_access_control_headers
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = '*'
      headers['Access-Control-Allow-Headers'] = '*'
      headers['Access-Control-Expose-Headers'] = %w[access-token expiry token-type client uid].join(', ')
      headers['Access-Control-Max-Age'] = '1728000'
    end

    # If this is a preflight OPTIONS request, then short-circuit the
    # request, return only the necessary headers and return an empty
    # text/plain.

    def cors_preflight_check
      render plain: '' if request.method == :options
    end
  end
end
