defmodule TemplatePhoenixApi.Repo.Migrations.CreateBlogPosts do
  use Ecto.Migration

  def change do
    create table(:blog_posts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string, null: false
      add :short_id, :string, null: false
      add :rich_text_content, :map, null: false
      add :status, :string, default: "draft", null: false
      add :tags, {:array, :string}, default: []
      add :published_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end

    create unique_index(:blog_posts, [:short_id])
    create index(:blog_posts, [:status])
    create index(:blog_posts, [:published_at])
  end
end
