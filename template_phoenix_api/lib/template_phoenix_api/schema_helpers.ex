defmodule TemplatePhoenixApi.SchemaHelpers do
  @moduledoc """
  Helper functions for GraphQL schema operations.
  
  This module provides utilities for schema introspection and export,
  similar to the Rails SchemaHelpers class.
  """

  alias TemplatePhoenixApiWeb.Schema

  @doc """
  Executes the GraphQL introspection query and returns the result as a JSON string.
  
  ## Examples
  
      iex> TemplatePhoenixApi.SchemaHelpers.execute_introspection_query()
      "{\"data\":{\"__schema\":{...}}}"
  """
  def execute_introspection_query do
    introspection_query = get_introspection_query()

    case Absinthe.run(introspection_query, Schema) do
      {:ok, result} ->
        Jason.encode!(result, pretty: true)

      {:error, error} ->
        raise "Failed to execute introspection query: #{inspect(error)}"
    end
  end

  @doc """
  Dumps the GraphQL schema to a specified file path.
  
  ## Parameters
  
    - schema_path: String path where the schema JSON should be written
  
  ## Examples
  
      TemplatePhoenixApi.SchemaHelpers.dump_schema("./data/schema.json")
  """
  def dump_schema(schema_path) do
    introspection_result = execute_introspection_query()
    
    # Ensure directory exists
    schema_path
    |> Path.dirname()
    |> File.mkdir_p!()
    
    File.write!(schema_path, introspection_result)
    
    IO.puts("Writing schema to #{schema_path}")
  end

  @doc """
  Generates GraphQL schema in SDL (Schema Definition Language) format.
  
  ## Examples
  
      iex> TemplatePhoenixApi.SchemaHelpers.generate_sdl()
      "type User { ... }"
  """
  def generate_sdl do
    Schema
    |> Absinthe.Schema.to_sdl()
  end

  @doc """
  Dumps the GraphQL schema in SDL format to a specified file path.
  
  ## Parameters
  
    - schema_path: String path where the schema SDL should be written
  
  ## Examples
  
      TemplatePhoenixApi.SchemaHelpers.dump_sdl("./data/schema.graphql")
  """
  def dump_sdl(schema_path) do
    sdl_content = generate_sdl()
    
    # Ensure directory exists
    schema_path
    |> Path.dirname()
    |> File.mkdir_p!()
    
    File.write!(schema_path, sdl_content)
    
    IO.puts("Writing SDL schema to #{schema_path}")
  end

  @doc """
  Validates the current GraphQL schema for any issues.
  
  Returns :ok if schema is valid, {:error, reasons} if there are issues.
  """
  def validate_schema do
    # Try to execute a simple introspection query to validate schema
    simple_query = "{ __schema { queryType { name } } }"
    
    case Absinthe.run(simple_query, Schema) do
      {:ok, _result} -> :ok
      {:error, errors} -> {:error, errors}
    end
  end

  @doc """
  Returns schema statistics including types, fields, and mutations count.
  """
  def schema_stats do
    {:ok, result} = Absinthe.run(get_introspection_query(), Schema)
    
    schema = get_in(result, [:data, :__schema]) || result["__schema"]
    types = schema[:types] || schema["types"] || []
    
    user_types = Enum.reject(types, fn type ->
      type_name = type[:name] || type["name"]
      String.starts_with?(type_name, "__")
    end)
    
    queries = case schema[:queryType] || schema["queryType"] do
      nil -> []
      query_type -> 
        query_type_name = query_type[:name] || query_type["name"]
        Enum.find(types, fn type -> 
          type_name = type[:name] || type["name"]
          type_name == query_type_name
        end)
        |> case do
          nil -> []
          found_type -> found_type[:fields] || found_type["fields"] || []
        end
    end
    
    mutations = case schema[:mutationType] || schema["mutationType"] do
      nil -> []
      mutation_type -> 
        mutation_type_name = mutation_type[:name] || mutation_type["name"]
        Enum.find(types, fn type -> 
          type_name = type[:name] || type["name"]
          type_name == mutation_type_name
        end)
        |> case do
          nil -> []
          found_type -> found_type[:fields] || found_type["fields"] || []
        end
    end

    %{
      total_types: length(types),
      user_types: length(user_types),
      queries: length(queries),
      mutations: length(mutations),
      directives: length(schema[:directives] || schema["directives"] || [])
    }
  end

  # Private helper to get the introspection query
  defp get_introspection_query do
    """
    query IntrospectionQuery {
      __schema {
        queryType { name }
        mutationType { name }
        subscriptionType { name }
        types {
          ...FullType
        }
        directives {
          name
          description
          locations
          args {
            ...InputValue
          }
        }
      }
    }

    fragment FullType on __Type {
      kind
      name
      description
      fields(includeDeprecated: true) {
        name
        description
        args {
          ...InputValue
        }
        type {
          ...TypeRef
        }
        isDeprecated
        deprecationReason
      }
      inputFields {
        ...InputValue
      }
      interfaces {
        ...TypeRef
      }
      enumValues(includeDeprecated: true) {
        name
        description
        isDeprecated
        deprecationReason
      }
      possibleTypes {
        ...TypeRef
      }
    }

    fragment InputValue on __InputValue {
      name
      description
      type { ...TypeRef }
      defaultValue
    }

    fragment TypeRef on __Type {
      kind
      name
      ofType {
        kind
        name
        ofType {
          kind
          name
          ofType {
            kind
            name
            ofType {
              kind
              name
              ofType {
                kind
                name
                ofType {
                  kind
                  name
                  ofType {
                    kind
                    name
                  }
                }
              }
            }
          }
        }
      }
    }
    """
  end
end