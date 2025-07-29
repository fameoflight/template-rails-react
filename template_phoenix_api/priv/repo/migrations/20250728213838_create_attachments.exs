defmodule TemplatePhoenixApi.Repo.Migrations.CreateAttachments do
  use Ecto.Migration

  def change do
    create table(:attachments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :content_type, :string
      add :url, :string
      add :record_id, :binary_id, null: false
      add :record_type, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create index(:attachments, [:record_id, :record_type])
    create index(:attachments, [:record_type])
  end
end
