defmodule Mix.Tasks.Graphql.Schema.Validate do
  @moduledoc """
  Validates the GraphQL schema for any issues and displays schema statistics.

  ## Usage

      mix graphql.schema.validate

  This will check the schema for any errors and display useful statistics
  about your GraphQL schema including type counts, query/mutation counts, etc.

  ## Examples

      # Validate schema and show stats
      mix graphql.schema.validate

      # Just validate without stats
      mix graphql.schema.validate --no-stats
  """

  use Mix.Task

  alias TemplatePhoenixApi.SchemaHelpers

  @shortdoc "Validates GraphQL schema and shows statistics"

  def run(args) do
    Mix.Task.run("app.start")

    {opts, _} = OptionParser.parse!(args,
      strict: [stats: :boolean],
      aliases: [s: :stats]
    )

    show_stats = Keyword.get(opts, :stats, true)

    # Validate schema
    case SchemaHelpers.validate_schema() do
      :ok ->
        Mix.shell().info("✅ GraphQL schema is valid!")
        
        if show_stats do
          display_schema_stats()
        end

      {:error, errors} ->
        Mix.shell().error("❌ GraphQL schema has errors:")
        
        Enum.each(errors, fn error ->
          Mix.shell().error("  - #{inspect(error)}")
        end)
        
        System.halt(1)
    end
  end

  defp display_schema_stats do
    stats = SchemaHelpers.schema_stats()
    
    Mix.shell().info("")
    Mix.shell().info("📊 Schema Statistics:")
    Mix.shell().info("  Total Types: #{stats.total_types}")
    Mix.shell().info("  User-defined Types: #{stats.user_types}")
    Mix.shell().info("  Query Fields: #{stats.queries}")
    Mix.shell().info("  Mutation Fields: #{stats.mutations}")
    Mix.shell().info("  Directives: #{stats.directives}")
  end
end