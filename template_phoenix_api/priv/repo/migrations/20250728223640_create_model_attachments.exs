defmodule TemplatePhoenixApi.Repo.Migrations.CreateModelAttachments do
  use Ecto.Migration

  def change do
    create table(:model_attachments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :owner_id, :binary_id, null: false
      add :owner_type, :string, null: false
      add :attachment_id, references(:attachments, on_delete: :delete_all, type: :binary_id), null: false

      timestamps()
    end

    create index(:model_attachments, [:attachment_id])
    create index(:model_attachments, [:owner_id, :owner_type])
    create unique_index(:model_attachments, [:owner_id, :owner_type, :name], name: :model_attachments_owner_name_index)
  end
end
