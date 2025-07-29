defmodule TemplatePhoenixApi.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :rich_text_content, :map, null: false
      add :rating, :decimal, precision: 3, scale: 2
      add :tags, {:array, :string}, default: []
      add :discarded_at, :utc_datetime
      add :commentable_id, :binary_id, null: false
      add :commentable_type, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:comments, [:commentable_id, :commentable_type])
    create index(:comments, [:user_id])
    create index(:comments, [:discarded_at])
  end
end
