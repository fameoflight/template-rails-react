defmodule TemplatePhoenixApi.Repo.Migrations.CreateJobRecords do
  use Ecto.Migration

  def change do
    create table(:job_records, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :active_job_id, :string
      add :concurrency_key, :string
      add :cron_at, :utc_datetime
      add :cron_key, :string
      add :error, :text
      add :finished_at, :utc_datetime
      add :performed_at, :utc_datetime
      add :priority, :integer
      add :queue_name, :string
      add :retried_good_job_id, :string
      add :scheduled_at, :utc_datetime
      add :serialized_params, :map
      add :super_user_id, references(:super_users, on_delete: :nilify_all, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:job_records, [:active_job_id])
    create index(:job_records, [:queue_name])
    create index(:job_records, [:scheduled_at])
    create index(:job_records, [:super_user_id])
  end
end
