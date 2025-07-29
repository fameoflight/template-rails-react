defmodule TemplatePhoenixApi.Repo.Migrations.CreateBlobs do
  use Ecto.Migration

  def change do
    create table(:blobs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :filename, :string, null: false
      add :content_type, :string, null: false
      add :byte_size, :bigint, null: false
      add :checksum, :string, null: false
      add :metadata, :map, default: %{}
      add :service_name, :string, default: "local"
      add :signed_id, :string
      add :uploaded_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end

    create unique_index(:blobs, [:checksum])
    create index(:blobs, [:content_type])
  end
end
