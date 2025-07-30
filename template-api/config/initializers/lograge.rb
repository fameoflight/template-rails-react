# frozen_string_literal: true

Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.ignore_actions = [
    'ActiveStorage::DiskController#show',
    'ActiveStorage::RepresentationsController#show'
  ]

  config.lograge.custom_options = lambda do |event|
    headers = event.payload[:headers] || {}
    params = event.payload[:params] || {}
    
    {
      host: event.payload[:host],
      commit: ENV.fetch('RAILWAY_GIT_COMMIT_SHA', nil),
      rails_env: Rails.env,
      process_id: Process.pid,
      request_id: headers['action_dispatch.request_id'],
      request_time: Time.zone.now,
      remote_ip: event.payload[:remote_ip],
      ip: event.payload[:ip],
      x_forwarded_for: event.payload[:x_forwarded_for],
      params: params.to_json,
      exception: event.payload[:exception],
      exception_object: event.payload[:exception_object]
    }.compact
  end
end
