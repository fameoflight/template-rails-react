defmodule TemplatePhoenixApi.Accounts.ApiAccessToken do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "api_access_tokens" do
    field :name, :string
    field :description, :string
    field :token, :string
    field :active, :boolean, default: true
    field :expires_at, :utc_datetime

    belongs_to :user, TemplatePhoenixApi.Accounts.User

    timestamps(type: :utc_datetime)
  end

  def changeset(api_access_token, attrs) do
    api_access_token
    |> cast(attrs, [:name, :description, :active, :expires_at, :user_id])
    |> validate_required([:name, :user_id])
    |> validate_length(:name, min: 1, max: 255)
    |> generate_token()
    |> unique_constraint(:token)
  end

  defp generate_token(%Ecto.Changeset{valid?: true} = changeset) do
    case get_field(changeset, :token) do
      nil ->
        token = generate_secure_token()
        put_change(changeset, :token, token)
      _token ->
        changeset
    end
  end

  defp generate_token(changeset), do: changeset

  defp generate_secure_token do
    prefix = if Application.get_env(:template_phoenix_api, :environment) == :prod, do: "prod", else: "dev"
    random_string = :crypto.strong_rand_bytes(32) |> Base.encode16(case: :lower)
    "#{prefix}_#{random_string}"
  end

  def expired?(%__MODULE__{expires_at: nil}), do: false
  def expired?(%__MODULE__{expires_at: expires_at}) do
    DateTime.compare(expires_at, DateTime.utc_now()) == :lt
  end

  def active?(%__MODULE__{active: active} = token) do
    active && !expired?(token)
  end
end