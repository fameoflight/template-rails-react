defmodule TemplatePhoenixApi.Content.BlogPost do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "blog_posts" do
    field :title, :string
    field :short_id, :string
    field :rich_text_content, :map
    field :status, :string, default: "draft"
    field :tags, {:array, :string}, default: []
    field :published_at, :utc_datetime

    has_many :attachments, TemplatePhoenixApi.Content.Attachment,
      foreign_key: :record_id,
      where: [record_type: "BlogPost"]

    has_many :comments, TemplatePhoenixApi.Content.Comment,
      foreign_key: :commentable_id,
      where: [commentable_type: "BlogPost"]

    timestamps(type: :utc_datetime)
  end

  def changeset(blog_post, attrs) do
    blog_post
    |> cast(attrs, [:title, :rich_text_content, :status, :tags, :published_at])
    |> validate_required([:title, :rich_text_content])
    |> validate_length(:title, min: 1, max: 255)
    |> validate_inclusion(:status, ["draft", "published"])
    |> generate_short_id()
    |> unique_constraint(:short_id)
    |> maybe_set_published_at()
  end

  defp generate_short_id(%Ecto.Changeset{valid?: true} = changeset) do
    case get_field(changeset, :short_id) do
      nil ->
        short_id = generate_unique_short_id()
        put_change(changeset, :short_id, short_id)
      _short_id ->
        changeset
    end
  end

  defp generate_short_id(changeset), do: changeset

  defp generate_unique_short_id do
    :crypto.strong_rand_bytes(8)
    |> Base.encode32(case: :lower, padding: false)
  end

  defp maybe_set_published_at(changeset) do
    status = get_change(changeset, :status)
    current_published_at = get_field(changeset, :published_at)

    case {status, current_published_at} do
      {"published", nil} ->
        put_change(changeset, :published_at, DateTime.utc_now() |> DateTime.truncate(:second))
      {"draft", _} ->
        put_change(changeset, :published_at, nil)
      _ ->
        changeset
    end
  end

  def published(query \\ __MODULE__) do
    from bp in query,
      where: bp.status == "published" and not is_nil(bp.published_at)
  end

  def draft(query \\ __MODULE__) do
    from bp in query,
      where: bp.status == "draft"
  end

  def by_status(query \\ __MODULE__, status) when status in ["all", "draft", "published"] do
    case status do
      "all" -> query
      "draft" -> draft(query)
      "published" -> published(query)
    end
  end
end