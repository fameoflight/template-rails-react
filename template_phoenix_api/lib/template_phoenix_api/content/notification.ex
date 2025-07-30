defmodule TemplatePhoenixApi.Content.Notification do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias TemplatePhoenixApi.Accounts.User

  @foreign_key_type :binary_id
  schema "notifications" do
    field :title, :string
    field :message, :string
    field :notification_type, :string
    field :read_at, :utc_datetime
    field :data, :map, default: %{}

    belongs_to :user, User, type: :binary_id

    timestamps()
  end

  @types [
    "message",
    "system", 
    "achievement",
    "reminder",
    "update",
    "warning",
    "error",
    "success"
  ]

  @doc false
  def changeset(notification, attrs) do
    notification
    |> cast(attrs, [:title, :message, :notification_type, :read_at, :data, :user_id])
    |> validate_required([:title, :message, :notification_type, :user_id])
    |> validate_inclusion(:notification_type, @types)
  end

  def unread(query \\ __MODULE__) do
    from(n in query, where: is_nil(n.read_at))
  end

  def read(query \\ __MODULE__) do
    from(n in query, where: not is_nil(n.read_at))
  end

  def recent(query \\ __MODULE__) do
    from(n in query, order_by: [desc: n.inserted_at])
  end

  def for_user(query \\ __MODULE__, user_id) do
    from(n in query, where: n.user_id == ^user_id)
  end

  def with_user(query \\ __MODULE__) do
    from(n in query, preload: [:user])
  end

  def read?(notification) do
    not is_nil(notification.read_at)
  end

  def unread?(notification) do
    is_nil(notification.read_at)
  end

  def mark_as_read!(notification) do
    notification
    |> changeset(%{read_at: DateTime.utc_now()})
    |> TemplatePhoenixApi.Repo.update!()
  end

  def icon(notification_type) do
    case notification_type do
      "message" -> "message"
      "system" -> "system"
      "achievement" -> "trophy"
      "reminder" -> "clock"
      "update" -> "sync"
      "warning" -> "warning"
      "error" -> "close-circle"
      "success" -> "check-circle"
      _ -> "bell"
    end
  end

  def color(notification_type) do
    case notification_type do
      "message" -> "blue"
      "system" -> "gray"
      "achievement" -> "gold"
      "reminder" -> "orange"
      "update" -> "cyan"
      "warning" -> "orange"
      "error" -> "red"
      "success" -> "green"
      _ -> "blue"
    end
  end

  def types, do: @types
end