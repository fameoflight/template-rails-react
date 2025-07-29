defmodule Mix.Tasks.Graphql do
  @moduledoc """
  GraphQL schema management tasks for Phoenix.

  This is the main GraphQL task that provides various subcommands for
  working with your GraphQL schema, similar to Rails rake tasks.

  ## Available subcommands:

    * `mix graphql.schema.dump` - Generates JSON introspection files
    * `mix graphql.schema.sdl` - Generates SDL (Schema Definition Language) files  
    * `mix graphql.schema.validate` - Validates schema and shows statistics

  ## Usage

      # Generate both JSON and SDL schema files
      mix graphql

      # Generate JSON introspection
      mix graphql.schema.dump

      # Generate SDL schema
      mix graphql.schema.sdl  

      # Validate schema
      mix graphql.schema.validate

  ## Examples

      # Generate all schema files and validate
      mix graphql

      # Generate schema files in custom locations
      mix graphql.schema.dump --path ./custom/schema.json
      mix graphql.schema.sdl --path ./custom/schema.graphql
  """

  use Mix.Task

  @shortdoc "GraphQL schema management (dump, validate, stats)"

  def run(_args) do
    Mix.shell().info("🚀 Running GraphQL schema operations...")
    
    # First validate the schema
    Mix.shell().info("\n📋 Validating schema...")
    Mix.Task.run("graphql.schema.validate")
    
    # Then generate JSON introspection
    Mix.shell().info("\n📄 Generating JSON schema files...")
    Mix.Task.run("graphql.schema.dump")
    
    # Finally generate SDL
    Mix.shell().info("\n📝 Generating SDL schema files...")
    Mix.Task.run("graphql.schema.sdl")
    
    Mix.shell().info("\n✅ All GraphQL operations completed successfully!")
  end
end