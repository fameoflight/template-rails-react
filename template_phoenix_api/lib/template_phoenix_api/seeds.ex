defmodule TemplatePhoenixApi.Seeds do
  @moduledoc """
  Utilities for database seeding, similar to Rails seed helpers.
  """
  
  alias TemplatePhoenixApi.Repo
  
  @doc """
  Find or create a record by given attributes.
  Similar to Rails' find_or_create_by!
  
  ## Examples
  
      user = Seeds.find_or_create_by!(User, %{email: "test@example.com"}, %{
        name: "Test User",
        password: "password123"
      })
  """
  def find_or_create_by!(schema, find_attrs, create_attrs \\ %{}) do
    case Repo.get_by(schema, find_attrs) do
      nil ->
        attrs = Map.merge(find_attrs, create_attrs)
        struct(schema, attrs)
        |> Repo.insert!()
        
      existing ->
        existing
    end
  end
  
  @doc """
  Create or update a record by given attributes.
  Similar to Rails' create_or_find_by!
  
  ## Examples
  
      user = Seeds.create_or_update_by!(User, %{email: "test@example.com"}, %{
        name: "Updated Name"
      })
  """
  def create_or_update_by!(schema, find_attrs, update_attrs \\ %{}) do
    case Repo.get_by(schema, find_attrs) do
      nil ->
        attrs = Map.merge(find_attrs, update_attrs)
        struct(schema, attrs)
        |> Repo.insert!()
        
      existing ->
        existing
        |> schema.changeset(update_attrs)
        |> Repo.update!()
    end
  end
  
  @doc """
  Insert multiple records efficiently.
  Similar to Rails' insert_all
  
  ## Examples
  
      Seeds.insert_all!(User, [
        %{email: "user1@example.com", name: "User 1"},
        %{email: "user2@example.com", name: "User 2"}
      ])
  """
  def insert_all!(schema, records, opts \\ []) do
    # Add timestamps if not present
    now = DateTime.utc_now() |> DateTime.truncate(:second)
    
    records_with_timestamps = Enum.map(records, fn record ->
      record
      |> Map.put_new(:inserted_at, now)
      |> Map.put_new(:updated_at, now)
    end)
    
    Repo.insert_all(schema, records_with_timestamps, opts)
  end
  
  @doc """
  Safely execute a function, catching and logging errors.
  Useful for non-critical seed operations.
  
  ## Examples
  
      Seeds.safe_execute("Creating sample data", fn ->
        # Some seeding operation that might fail
      end)
  """
  def safe_execute(description, func) do
    try do
      result = func.()
      IO.puts("  ✓ #{description}")
      {:ok, result}
    rescue
      error ->
        IO.puts("  ❌ Failed #{description}: #{Exception.message(error)}")
        {:error, error}
    end
  end
  
  @doc """
  Check if we're in a safe environment for seeding.
  """
  def safe_environment? do
    Mix.env() in [:development, :test] or 
    System.get_env("FORCE_SEED") == "true"
  end
  
  @doc """
  Generate a random string for testing.
  """
  def random_string(length \\ 10) do
    :crypto.strong_rand_bytes(length)
    |> Base.url_encode64(padding: false)
    |> String.slice(0, length)
  end
  
  @doc """
  Print a banner for seed operations.
  """
  def print_banner(message) do
    border = String.duplicate("=", String.length(message) + 4)
    IO.puts("\n#{border}")
    IO.puts("  #{message}")  
    IO.puts("#{border}\n")
  end
end