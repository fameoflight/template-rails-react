defmodule TemplatePhoenixApi.Repo.Migrations.CreateNotifications do
  use Ecto.Migration

  def change do
    create table(:notifications) do
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id), null: false
      add :title, :string
      add :message, :text
      add :notification_type, :string
      add :read_at, :utc_datetime
      add :data, :map

      timestamps()
    end

    create index(:notifications, [:user_id])
  end
end
