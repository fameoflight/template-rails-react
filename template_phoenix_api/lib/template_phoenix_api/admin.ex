defmodule TemplatePhoenixApi.Admin do
  @moduledoc """
  The Admin context.
  """

  import Ecto.Query, warn: false
  alias TemplatePhoenixApi.Repo
  alias TemplatePhoenixApi.Admin.SuperUser

  @doc """
  Returns the list of super_users.
  """
  def list_super_users do
    Repo.all(SuperUser)
  end

  @doc """
  Gets a single super_user.
  """
  def get_super_user!(id), do: Repo.get!(SuperUser, id)

  @doc """
  Gets a single super_user.
  """
  def get_super_user(id), do: Repo.get(SuperUser, id)

  @doc """
  Creates a super_user.
  """
  def create_super_user(attrs \\ %{}) do
    %SuperUser{}
    |> SuperUser.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a super_user.
  """
  def update_super_user(%SuperUser{} = super_user, attrs) do
    super_user
    |> SuperUser.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a super_user.
  """
  def delete_super_user(%SuperUser{} = super_user) do
    Repo.delete(super_user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking super_user changes.
  """
  def change_super_user(%SuperUser{} = super_user, attrs \\ %{}) do
    SuperUser.changeset(super_user, attrs)
  end
end