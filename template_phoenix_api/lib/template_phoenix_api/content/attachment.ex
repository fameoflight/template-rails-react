defmodule TemplatePhoenixApi.Content.Attachment do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "attachments" do
    field :name, :string
    field :content_type, :string
    field :url, :string
    field :record_id, :binary_id
    field :record_type, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(attachment, attrs) do
    attachment
    |> cast(attrs, [:name, :content_type, :url, :record_id, :record_type])
    |> validate_required([:name, :record_id, :record_type])
    |> validate_length(:name, min: 1, max: 255)
    |> validate_inclusion(:record_type, ["User", "BlogPost", "Comment"])
  end

  def for_record(query \\ __MODULE__, record_id, record_type) do
    from a in query,
      where: a.record_id == ^record_id and a.record_type == ^record_type
  end
end