defmodule TemplatePhoenixApi.Content.ModelAttachment do
  @moduledoc """
  ModelAttachment schema for linking attachments to various models.
  
  This is a polymorphic association that allows any model to have
  named attachments, similar to Rails' has_many_attached.
  """
  
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  
  alias TemplatePhoenixApi.Content.Attachment
  
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  
  schema "model_attachments" do
    field :name, :string
    field :owner_id, :binary_id
    field :owner_type, :string
    
    belongs_to :attachment, Attachment
    
    timestamps()
  end
  
  @doc false
  def changeset(model_attachment, attrs) do
    model_attachment
    |> cast(attrs, [:name, :owner_id, :owner_type, :attachment_id])
    |> validate_required([:name, :owner_id, :owner_type, :attachment_id])
    |> validate_length(:name, min: 1, max: 255)
    |> validate_length(:owner_type, min: 1, max: 100)
    |> foreign_key_constraint(:attachment_id)
    |> unique_constraint([:owner_id, :owner_type, :name], 
         name: :model_attachments_owner_name_index)
  end
  
  @doc """
  Get all model attachments for a given owner.
  """
  def for_owner(owner_id, owner_type) when is_binary(owner_id) and is_binary(owner_type) do
    from ma in __MODULE__,
      where: ma.owner_id == ^owner_id and ma.owner_type == ^owner_type,
      preload: [:attachment]
  end
  
  @doc """
  Get a specific named attachment for an owner.
  """
  def for_owner_with_name(owner_id, owner_type, name) when is_binary(name) do
    from ma in __MODULE__,
      where: ma.owner_id == ^owner_id and ma.owner_type == ^owner_type and ma.name == ^name,
      preload: [:attachment]
  end
end