# frozen_string_literal: true

Rails.application.configure do
  config.good_job.preserve_job_records = false
  config.good_job.retry_on_unhandled_error = false
  # bugsnag automatically detects the environment and adds it to the payload
  # config.good_job.on_thread_error = ->(exception) { Bugsnag.notify(exception) }
  config.good_job.queues = '*'
  config.good_job.max_threads = 5
  config.good_job.poll_interval = 30 # seconds
  config.good_job.shutdown_timeout = 25 # seconds
  config.good_job.enable_cron = true
  config.good_job.cron = {
    'good_job_cleanup' => { cron: '0 0 * * *', class: 'GoodJob::ActiveJob::CleanupJob' }
  }
end
