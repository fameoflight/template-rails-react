defmodule TemplatePhoenixApi.Repo.Migrations.CreateApiAccessTokens do
  use Ecto.Migration

  def change do
    create table(:api_access_tokens, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :description, :text
      add :token, :string, null: false
      add :active, :boolean, default: true, null: false
      add :expires_at, :utc_datetime
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id), null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:api_access_tokens, [:token])
    create index(:api_access_tokens, [:user_id])
    create index(:api_access_tokens, [:active])
  end
end
