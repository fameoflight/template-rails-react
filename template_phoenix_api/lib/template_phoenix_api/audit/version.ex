defmodule TemplatePhoenixApi.Audit.Version do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "versions" do
    field :event, :string
    field :item_id, :binary_id
    field :item_type, :string
    field :whodunnit, :string
    field :metadata, :map
    field :changes, :map

    belongs_to :user, TemplatePhoenixApi.Accounts.User

    timestamps(type: :utc_datetime)
  end

  def changeset(version, attrs) do
    version
    |> cast(attrs, [:event, :item_id, :item_type, :whodunnit, :metadata, :changes, :user_id])
    |> validate_required([:event, :item_id, :item_type])
    |> validate_inclusion(:event, ["create", "update", "delete"])
  end

  def for_item(query \\ __MODULE__, item_id, item_type) do
    from v in query,
      where: v.item_id == ^item_id and v.item_type == ^item_type,
      order_by: [desc: v.inserted_at]
  end

  def version_changes(%__MODULE__{changes: changes}) when is_map(changes) do
    Enum.map(changes, fn {field, %{"from" => from_val, "to" => to_val}} ->
      %{
        label: humanize_field(field),
        previous_value: format_value(from_val),
        new_value: format_value(to_val)
      }
    end)
  end

  def version_changes(_), do: []

  defp humanize_field(field) when is_atom(field), do: humanize_field(Atom.to_string(field))
  defp humanize_field(field) when is_binary(field) do
    field
    |> String.replace("_", " ")
    |> String.split()
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end

  defp format_value(nil), do: nil
  defp format_value(value) when is_binary(value), do: value
  defp format_value(value), do: inspect(value)
end