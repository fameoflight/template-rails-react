defmodule TemplatePhoenixApi.Content.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "comments" do
    field :rich_text_content, :map
    field :rating, :decimal
    field :tags, {:array, :string}, default: []
    field :discarded_at, :utc_datetime
    field :commentable_id, :binary_id
    field :commentable_type, :string

    belongs_to :user, TemplatePhoenixApi.Accounts.User

    timestamps(type: :utc_datetime)
  end

  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:rich_text_content, :rating, :tags, :commentable_id, :commentable_type, :user_id])
    |> validate_required([:rich_text_content, :commentable_id, :commentable_type, :user_id])
    |> validate_inclusion(:commentable_type, ["BlogPost", "ApiAccessToken"])
    |> validate_number(:rating, greater_than_or_equal_to: 0.0, less_than_or_equal_to: 5.0)
  end

  def discard_changeset(comment) do
    comment
    |> change()
    |> put_change(:discarded_at, DateTime.utc_now() |> DateTime.truncate(:second))
  end

  def not_discarded(query \\ __MODULE__) do
    from c in query,
      where: is_nil(c.discarded_at)
  end

  def for_commentable(query \\ __MODULE__, commentable_id, commentable_type) do
    from c in query,
      where: c.commentable_id == ^commentable_id and c.commentable_type == ^commentable_type
  end

  def count_for_commentable(commentable_id, commentable_type) do
    __MODULE__
    |> for_commentable(commentable_id, commentable_type)
    |> not_discarded()
    |> select([c], count(c.id))
  end
end