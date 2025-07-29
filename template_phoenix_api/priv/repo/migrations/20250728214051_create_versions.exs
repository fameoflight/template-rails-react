defmodule TemplatePhoenixApi.Repo.Migrations.CreateVersions do
  use Ecto.Migration

  def change do
    create table(:versions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :event, :string, null: false
      add :item_id, :binary_id, null: false
      add :item_type, :string, null: false
      add :whodunnit, :string
      add :metadata, :map
      add :changes, :map
      add :user_id, references(:users, on_delete: :nilify_all, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:versions, [:item_id, :item_type])
    create index(:versions, [:event])
    create index(:versions, [:user_id])
  end
end
