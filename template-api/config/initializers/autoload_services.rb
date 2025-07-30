# frozen_string_literal: true

# Ensure services are autoloaded
Rails.application.config.to_prepare do
  require_dependency 'broadcast_service' if Rails.env.development?
end