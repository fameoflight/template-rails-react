# frozen_string_literal: true

class ApplicationJob < ActiveJob::Base
  include GoodJob::ActiveJobExtensions::Concurrency

  good_job_control_concurrency_with(
    total_limit: 5,
    enqueue_limit: 2,
    perform_limit: 1,
    key: -> { "#{self.class}-#{SecureRandom.uuid}" }
  )
end
