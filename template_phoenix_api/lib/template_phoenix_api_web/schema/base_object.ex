defmodule TemplatePhoenixApiWeb.Schema.BaseObject do
  @moduledoc """
  Base object module that provides common GraphQL fields and functionality.
  Similar to Rails ApplicationRecord but for GraphQL types.
  """
  
  defmacro __using__(_opts \\ []) do
    quote do
      use Absinthe.Schema.Notation
      import TemplatePhoenixApiWeb.Schema.BaseObject
    end
  end
  
  @doc """
  Adds model interface (includes node interface)
  """
  defmacro model_interface do
    quote do
      interface :model_interface
      interface :node
    end
  end
  
  @doc """
  Adds just the node interface
  """
  defmacro node_interface do
    quote do
      interface :node
    end
  end
  
  @doc """
  Adds standard timestamp fields (created_at, updated_at) that map to Phoenix conventions
  """
  defmacro timestamps do
    quote do
      field :created_at, non_null(:iso8601_datetime) do
        resolve fn parent, _args, _context ->
          # Convert NaiveDateTime to DateTime for proper ISO8601 serialization
          {:ok, DateTime.from_naive!(parent.inserted_at, "Etc/UTC")}
        end
      end
      
      field :updated_at, non_null(:iso8601_datetime) do
        resolve fn parent, _args, _context ->
          # Convert NaiveDateTime to DateTime for proper ISO8601 serialization
          {:ok, DateTime.from_naive!(parent.updated_at, "Etc/UTC")}
        end
      end
    end
  end
  
  @doc """
  Adds model_id field that creates Rails-compatible integer ID from UUID
  """
  defmacro model_id do
    quote do
      field :model_id, non_null(:integer) do
        resolve fn parent, _args, _context ->
          case parent.id do
            id when is_binary(id) ->
              # Create a consistent integer from UUID for Rails compatibility
              {:ok, :crypto.hash(:md5, id) |> :binary.decode_unsigned() |> rem(2147483647)}
            _ ->
              {:ok, 0}
          end
        end
      end
    end
  end
  
  @doc """
  Standard fields that most models need (id + timestamps + model_id)
  Includes both Phoenix conventions (inserted_at) and Rails conventions (created_at/updated_at)
  """
  defmacro standard_fields do
    quote do
      field :id, non_null(:id)
      model_id()
      timestamps()
      
      # Keep Phoenix inserted_at for internal use
      field :inserted_at, non_null(:iso8601_datetime) do
        resolve fn parent, _args, _context ->
          # Convert NaiveDateTime to DateTime for proper ISO8601 serialization
          {:ok, DateTime.from_naive!(parent.inserted_at, "Etc/UTC")}
        end
      end
    end
  end
  
  @doc """
  Implements all model interface fields (for objects that implement model_interface)
  """
  defmacro model_fields do
    quote do
      field :id, non_null(:id), description: "ID of the object."
      
      field :model_id, non_null(:integer) do
        resolve fn parent, _args, _context ->
          case parent.id do
            id when is_binary(id) ->
              # Create a consistent integer from UUID for Rails compatibility
              {:ok, :crypto.hash(:md5, id) |> :binary.decode_unsigned() |> rem(2147483647)}
            _ ->
              {:ok, 0}
          end
        end
      end
      
      field :created_at, non_null(:iso8601_datetime) do
        resolve fn parent, _args, _context ->
          # Convert NaiveDateTime to DateTime for proper ISO8601 serialization
          {:ok, DateTime.from_naive!(parent.inserted_at, "Etc/UTC")}
        end
      end
      
      field :updated_at, non_null(:iso8601_datetime) do
        resolve fn parent, _args, _context ->
          # Convert NaiveDateTime to DateTime for proper ISO8601 serialization
          {:ok, DateTime.from_naive!(parent.updated_at, "Etc/UTC")}
        end
      end
    end
  end
end