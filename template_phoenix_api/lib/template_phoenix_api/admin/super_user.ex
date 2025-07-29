defmodule TemplatePhoenixApi.Admin.SuperUser do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "super_users" do
    field :name, :string

    has_many :job_records, TemplatePhoenixApi.Jobs.JobRecord

    timestamps(type: :utc_datetime)
  end

  def changeset(super_user, attrs) do
    super_user
    |> cast(attrs, [:name])
    |> validate_length(:name, max: 255)
  end

  def search_users(query \\ TemplatePhoenixApi.Accounts.User, term)

  def search_users(query, term) when is_binary(term) do
    search_term = "%#{term}%"
    
    from u in query,
      where: ilike(u.name, ^search_term) or ilike(u.email, ^search_term)
  end

  def search_users(query, _term), do: query
end