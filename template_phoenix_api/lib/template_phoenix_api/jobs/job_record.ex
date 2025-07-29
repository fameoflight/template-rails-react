defmodule TemplatePhoenixApi.Jobs.JobRecord do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "job_records" do
    field :active_job_id, :string
    field :concurrency_key, :string
    field :cron_at, :utc_datetime
    field :cron_key, :string
    field :error, :string
    field :finished_at, :utc_datetime
    field :performed_at, :utc_datetime
    field :priority, :integer
    field :queue_name, :string
    field :retried_good_job_id, :string
    field :scheduled_at, :utc_datetime
    field :serialized_params, :map

    belongs_to :super_user, TemplatePhoenixApi.Admin.SuperUser

    timestamps(type: :utc_datetime)
  end

  def changeset(job_record, attrs) do
    job_record
    |> cast(attrs, [
      :active_job_id, :concurrency_key, :cron_at, :cron_key, :error,
      :finished_at, :performed_at, :priority, :queue_name, :retried_good_job_id,
      :scheduled_at, :serialized_params, :super_user_id
    ])
    |> validate_number(:priority, greater_than_or_equal_to: 0)
  end
end