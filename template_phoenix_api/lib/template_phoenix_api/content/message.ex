defmodule TemplatePhoenixApi.Content.Message do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias TemplatePhoenixApi.Accounts.User

  @foreign_key_type :binary_id
  schema "messages" do
    field :content, :string
    field :room_id, :string

    belongs_to :user, User, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content, :room_id, :user_id])
    |> validate_required([:content, :room_id, :user_id])
    |> validate_length(:content, min: 1, max: 10000)
    |> validate_length(:room_id, min: 1, max: 255)
  end

  def for_room(query \\ __MODULE__, room_id) do
    from(m in query, where: m.room_id == ^room_id)
  end

  def recent(query \\ __MODULE__) do
    from(m in query, order_by: [desc: m.inserted_at])
  end

  def with_user(query \\ __MODULE__) do
    from(m in query, preload: [:user])
  end
end