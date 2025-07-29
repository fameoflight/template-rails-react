defmodule Mix.Tasks.Graphql.Schema.Dump do
  @moduledoc """
  Generates GraphQL schema introspection and writes it to JSON files.

  This task is equivalent to the Rails `rake graphql:schema:dump` task.

  ## Usage

      mix graphql.schema.dump

  This will generate schema.json files in:
  - ./data/schema.json (main API folder)
  - ../template-web/data/schema.json (webapp folder if it exists)

  ## Examples

      # Generate schema files
      mix graphql.schema.dump

      # Generate schema with custom path
      mix graphql.schema.dump --path ./custom/schema.json
  """

  use Mix.Task

  alias TemplatePhoenixApiWeb.Schema

  @shortdoc "Generates GraphQL schema introspection files"

  def run(args) do
    Mix.Task.run("app.start")

    {opts, _} =
      OptionParser.parse!(args,
        strict: [path: :string],
        aliases: [p: :path]
      )

    if opts[:path] do
      dump_schema(opts[:path])
    else
      dump_default_schemas()
    end
  end

  defp dump_default_schemas do
    project_name = get_project_name()

    schema_dirs = [
      # main folder
      "./data",
      # webapp folder
      "../#{project_name}-web/data"
    ]

    Enum.each(schema_dirs, fn schema_dir ->
      File.mkdir_p!(schema_dir)
      schema_path = Path.join(schema_dir, "schema.json")
      dump_schema(schema_path)
    end)
  end

  defp dump_schema(schema_path) do
    introspection_query = execute_introspection_query()

    File.write!(schema_path, introspection_query)

    # Also generate SDL format

    Mix.shell().info("Writing schema to #{schema_path}")
  end

  defp execute_introspection_query do
    introspection_query = """
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

    case Absinthe.run(introspection_query, Schema) do
      {:ok, result} ->
        result
        |> Jason.encode!(pretty: true)

      {:error, error} ->
        Mix.raise("Failed to execute introspection query: #{inspect(error)}")
    end
  end

  defp get_project_name do
    # Get project name from mix.exs or directory name
    case Mix.Project.config()[:app] do
      nil ->
        Path.basename(File.cwd!())
        |> String.replace("_", "-")
        |> String.split("-")
        |> List.first()
        |> Kernel.||("template")

      app_name ->
        app_name
        |> Atom.to_string()
        |> String.replace("_", "-")
        |> String.split("-")
        |> List.first()
    end
  end
end
