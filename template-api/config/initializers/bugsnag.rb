# frozen_string_literal: true

Bugsnag.configure do |config|
  config.notify_release_stages = ['production']

  config.api_key = Rails.application.credentials[:bugsnag_token]

  config.app_version = ENV.fetch('RAILWAY_GIT_COMMIT_SHA', nil)
end
