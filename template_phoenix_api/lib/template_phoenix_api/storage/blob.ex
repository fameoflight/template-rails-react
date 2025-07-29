defmodule TemplatePhoenixApi.Storage.Blob do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "blobs" do
    field :filename, :string
    field :content_type, :string
    field :byte_size, :integer
    field :checksum, :string
    field :metadata, :map, default: %{}
    field :service_name, :string, default: "local"
    field :signed_id, :string
    field :uploaded_at, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  def changeset(blob, attrs) do
    blob
    |> cast(attrs, [:filename, :content_type, :byte_size, :checksum, :metadata, :service_name])
    |> validate_required([:filename, :content_type, :byte_size, :checksum])
    |> validate_length(:filename, min: 1, max: 255)
    |> validate_number(:byte_size, greater_than: 0)
    |> generate_signed_id()
    |> unique_constraint(:checksum)
  end

  defp generate_signed_id(%Ecto.Changeset{valid?: true} = changeset) do
    case get_field(changeset, :signed_id) do
      nil ->
        signed_id = generate_unique_signed_id()
        put_change(changeset, :signed_id, signed_id)
      _signed_id ->
        changeset
    end
  end

  defp generate_signed_id(changeset), do: changeset

  defp generate_unique_signed_id do
    :crypto.strong_rand_bytes(32)
    |> Base.url_encode64(padding: false)
    |> String.slice(0, 27)  # Make it similar to Rails signed_id length
  end

  # File type validation
  @allowed_image_types ~w(image/png image/jpeg image/gif image/webp)
  @allowed_document_types ~w(application/pdf text/plain application/msword 
                            application/vnd.openxmlformats-officedocument.wordprocessingml.document
                            application/vnd.ms-excel
                            application/vnd.openxmlformats-officedocument.spreadsheetml.sheet)

  def allowed_content_types do
    @allowed_image_types ++ @allowed_document_types
  end

  def image?(content_type) do
    content_type in @allowed_image_types
  end

  def content_type_allowed?(content_type) do
    content_type in allowed_content_types()
  end

  # File size limits (in bytes)
  @max_file_size 50 * 1024 * 1024  # 50MB
  @max_image_size 10 * 1024 * 1024  # 10MB

  def max_file_size, do: @max_file_size
  def max_image_size, do: @max_image_size

  def size_within_limit?(byte_size, content_type) do
    limit = if image?(content_type), do: @max_image_size, else: @max_file_size
    byte_size <= limit
  end

  # Generate URLs for direct upload (simplified version)
  def service_url_for_direct_upload(%__MODULE__{} = blob) do
    # In production, this would generate a signed URL for S3/GCS/etc
    # For now, return a local upload endpoint
    "/api/uploads/#{blob.signed_id}"
  end

  def service_headers_for_direct_upload(%__MODULE__{} = blob) do
    # Headers needed for direct upload
    %{
      "Content-Type" => blob.content_type,
      "Content-MD5" => blob.checksum
    }
  end

  def public_url(%__MODULE__{} = blob) do
    # Public URL where the file can be accessed
    "/api/files/#{blob.signed_id}/#{blob.filename}"
  end

  def mark_uploaded(%__MODULE__{} = blob) do
    blob
    |> change()
    |> put_change(:uploaded_at, DateTime.utc_now() |> DateTime.truncate(:second))
  end
end