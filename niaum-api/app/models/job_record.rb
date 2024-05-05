# frozen_string_literal: true

# == Schema Information
#
# Table name: good_jobs
#
#  id                  :uuid             not null, primary key
#  concurrency_key     :text             indexed
#  cron_at             :datetime         indexed => [cron_key]
#  cron_key            :text             indexed => [created_at], indexed => [cron_at]
#  error               :text
#  error_event         :integer
#  executions_count    :integer
#  finished_at         :datetime         indexed
#  is_discrete         :boolean
#  job_class           :text
#  labels              :text             is an Array, indexed
#  performed_at        :datetime
#  priority            :integer          indexed => [created_at], indexed => [created_at]
#  queue_name          :text             indexed => [scheduled_at]
#  scheduled_at        :datetime         indexed => [queue_name], indexed
#  serialized_params   :jsonb
#  created_at          :datetime         not null, indexed => [priority], indexed => [priority], indexed => [active_job_id], indexed => [cron_key]
#  updated_at          :datetime         not null
#  active_job_id       :uuid             indexed => [created_at]
#  batch_callback_id   :uuid             indexed
#  batch_id            :uuid             indexed
#  retried_good_job_id :uuid
#
# Indexes
#
#  index_good_job_jobs_for_candidate_lookup                     (priority,created_at) WHERE (finished_at IS NULL)
#  index_good_jobs_jobs_on_finished_at                          (finished_at) WHERE ((retried_good_job_id IS NULL) AND (finished_at IS NOT NULL))
#  index_good_jobs_jobs_on_priority_created_at_when_unfinished  (priority DESC NULLS LAST,created_at) WHERE (finished_at IS NULL)
#  index_good_jobs_on_active_job_id_and_created_at              (active_job_id,created_at)
#  index_good_jobs_on_batch_callback_id                         (batch_callback_id) WHERE (batch_callback_id IS NOT NULL)
#  index_good_jobs_on_batch_id                                  (batch_id) WHERE (batch_id IS NOT NULL)
#  index_good_jobs_on_concurrency_key_when_unfinished           (concurrency_key) WHERE (finished_at IS NULL)
#  index_good_jobs_on_cron_key_and_created_at_cond              (cron_key,created_at) WHERE (cron_key IS NOT NULL)
#  index_good_jobs_on_cron_key_and_cron_at_cond                 (cron_key,cron_at) UNIQUE WHERE (cron_key IS NOT NULL)
#  index_good_jobs_on_labels                                    (labels) WHERE (labels IS NOT NULL) USING gin
#  index_good_jobs_on_queue_name_and_scheduled_at               (queue_name,scheduled_at) WHERE (finished_at IS NULL)
#  index_good_jobs_on_scheduled_at                              (scheduled_at) WHERE (finished_at IS NULL)
#
class JobRecord < GoodJob::Job
  include ModelGraphqlable
end
