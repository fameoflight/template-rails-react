defmodule TemplatePhoenixApi.Storage do
  @moduledoc """
  The Storage context for file uploads and blob management.
  """

  import Ecto.Query, warn: false
  alias TemplatePhoenixApi.Repo
  alias TemplatePhoenixApi.Storage.Blob

  @doc """
  Creates a blob for direct upload.
  """
  def create_blob_for_direct_upload(attrs) do
    %Blob{}
    |> Blob.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Gets a blob by signed_id.
  """
  def get_blob_by_signed_id(signed_id) do
    Repo.get_by(Blob, signed_id: signed_id)
  end

  @doc """
  Gets a blob by id.
  """
  def get_blob!(id), do: Repo.get!(Blob, id)

  @doc """
  Marks a blob as uploaded.
  """
  def mark_blob_uploaded(%Blob{} = blob) do
    blob
    |> Blob.mark_uploaded()
    |> Repo.update()
  end

  @doc """
  Validates file upload parameters.
  """
  def validate_upload_params(attrs, user_context \\ %{}) do
    with {:ok, byte_size} <- validate_byte_size(attrs["byte_size"] || attrs[:byte_size]),
         {:ok, content_type} <- validate_content_type(attrs["content_type"] || attrs[:content_type]),
         :ok <- validate_file_size_limit(byte_size, content_type, user_context),
         :ok <- validate_file_type_allowed(content_type, user_context) do
      {:ok, %{byte_size: byte_size, content_type: content_type}}
    end
  end

  defp validate_byte_size(byte_size) when is_integer(byte_size) and byte_size > 0, do: {:ok, byte_size}
  defp validate_byte_size(_), do: {:error, ["Invalid file size"]}

  defp validate_content_type(content_type) when is_binary(content_type), do: {:ok, content_type}
  defp validate_content_type(_), do: {:error, ["Invalid content type"]}

  defp validate_file_size_limit(byte_size, content_type, _user_context) do
    if Blob.size_within_limit?(byte_size, content_type) do
      :ok
    else
      {:error, ["File size is too large"]}
    end
  end

  defp validate_file_type_allowed(content_type, _user_context) do
    if Blob.content_type_allowed?(content_type) do
      :ok
    else
      {:error, ["File type is not allowed"]}
    end
  end

  @doc """
  Lists all blobs.
  """
  def list_blobs do
    Repo.all(Blob)
  end

  @doc """
  Deletes a blob.
  """
  def delete_blob(%Blob{} = blob) do
    Repo.delete(blob)
  end
end