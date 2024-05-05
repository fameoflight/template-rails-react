# frozen_string_literal: true

module Types
  module Model
    class JobRecordType < Types::BaseModelObject
      setup JobRecord,
            fields: %i[concurrency_key cron_at cron_key error finished_at performed_at priority queue_name scheduled_at serialized_params
                       created_at updated_at active_job_id retried_good_job_id]
    end
  end
end
