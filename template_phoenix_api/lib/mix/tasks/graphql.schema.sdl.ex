defmodule Mix.Tasks.Graphql.Schema.Sdl do
  @moduledoc """
  Generates GraphQL schema in SDL (Schema Definition Language) format.

  ## Usage

      mix graphql.schema.sdl

  This will generate schema.graphql files in:
  - ./data/schema.graphql (main API folder)
  - ../template-web/data/schema.graphql (webapp folder if it exists)

  ## Examples

      # Generate SDL schema files
      mix graphql.schema.sdl

      # Generate SDL schema with custom path
      mix graphql.schema.sdl --path ./custom/schema.graphql
  """

  use Mix.Task

  alias TemplatePhoenixApi.SchemaHelpers

  @shortdoc "Generates GraphQL schema in SDL format"

  def run(args) do
    Mix.Task.run("app.start")

    {opts, _} =
      OptionParser.parse!(args,
        strict: [path: :string],
        aliases: [p: :path]
      )

    if opts[:path] do
      SchemaHelpers.dump_sdl(opts[:path])
    else
      dump_default_sdl_schemas()
    end
  end

  defp dump_default_sdl_schemas do
    schema_dirs = [
      # main folder
      "./data"
    ]

    Enum.each(schema_dirs, fn schema_dir ->
      File.mkdir_p!(schema_dir)
      schema_path = Path.join(schema_dir, "schema.graphql")
      SchemaHelpers.dump_sdl(schema_path)
    end)
  end
end
