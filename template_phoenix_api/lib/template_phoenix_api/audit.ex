defmodule TemplatePhoenixApi.Audit do
  @moduledoc """
  The Audit context.
  """

  import Ecto.Query, warn: false
  alias TemplatePhoenixApi.Repo
  alias TemplatePhoenixApi.Audit.Version

  @doc """
  Returns the list of versions.
  """
  def list_versions do
    Repo.all(Version)
  end

  @doc """
  Gets a single version.
  """
  def get_version!(id), do: Repo.get!(Version, id)

  @doc """
  Gets a single version.
  """
  def get_version(id), do: Repo.get(Version, id)

  @doc """
  Creates a version.
  """
  def create_version(attrs \\ %{}) do
    %Version{}
    |> Version.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a version.
  """
  def update_version(%Version{} = version, attrs) do
    version
    |> Version.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a version.
  """
  def delete_version(%Version{} = version) do
    Repo.delete(version)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking version changes.
  """
  def change_version(%Version{} = version, attrs \\ %{}) do
    Version.changeset(version, attrs)
  end
end