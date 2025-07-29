# GraphQL Mix Tasks

This Phoenix project includes several Mix tasks for managing GraphQL schemas, similar to the Rails `rake graphql:*` tasks.

## Available Tasks

### `mix graphql`
**Main umbrella task** - Runs validation, JSON generation, and SDL generation in sequence.

```bash
mix graphql
```

This will:
1. Validate the GraphQL schema
2. Generate JSON introspection files
3. Generate SDL (Schema Definition Language) files
4. Show schema statistics

### `mix graphql.schema.dump`
**Generate JSON introspection files** - Creates JSON schema files for tooling and client libraries.

```bash
# Generate default schema files
mix graphql.schema.dump

# Generate to custom path
mix graphql.schema.dump --path ./custom/schema.json
```

**Output locations:**
- `./data/schema.json` (main API folder)
- `../template-web/data/schema.json` (webapp folder, if exists)

### `mix graphql.schema.sdl`
**Generate SDL schema files** - Creates human-readable GraphQL schema files.

```bash
# Generate default SDL files
mix graphql.schema.sdl

# Generate to custom path
mix graphql.schema.sdl --path ./custom/schema.graphql
```

**Output locations:**
- `./data/schema.graphql` (main API folder)
- `../template-web/data/schema.graphql` (webapp folder, if exists)

### `mix graphql.schema.validate`
**Validate schema and show statistics** - Checks schema for errors and displays useful metrics.

```bash
# Validate and show stats
mix graphql.schema.validate

# Validate without stats
mix graphql.schema.validate --no-stats
```

## Usage Examples

### Development Workflow
```bash
# After making GraphQL schema changes, run:
mix graphql

# This will validate your changes and update all schema files
```

### CI/CD Pipeline
```bash
# Validate schema in CI
mix graphql.schema.validate

# Generate fresh schema files for deployment
mix graphql.schema.dump
mix graphql.schema.sdl
```

### Client Integration
```bash
# Generate schema for frontend/mobile clients
mix graphql.schema.dump --path ./client-schemas/api-schema.json

# Generate SDL for documentation or GraphQL Playground
mix graphql.schema.sdl --path ./docs/api-schema.graphql
```

## Schema Statistics

The validation task provides useful metrics about your GraphQL schema:

- **Total Types**: All types including built-in GraphQL types
- **User-defined Types**: Your custom types (excludes `__` prefixed types)
- **Query Fields**: Number of available query operations
- **Mutation Fields**: Number of available mutation operations
- **Directives**: Number of schema directives

## Integration with Rails Project

These tasks are designed to work seamlessly with the existing Rails GraphQL setup:

1. **Compatible Output**: JSON and SDL formats match Rails output
2. **Same File Locations**: Generates files in the same locations as Rails rake tasks
3. **Client Compatibility**: Generated schemas work with existing frontend tooling

## Helper Module

The tasks use `TemplatePhoenixApi.SchemaHelpers` which provides programmatic access:

```elixir
# In IEx or other Elixir code
alias TemplatePhoenixApi.SchemaHelpers

# Generate JSON introspection
json_schema = SchemaHelpers.execute_introspection_query()

# Generate SDL
sdl_schema = SchemaHelpers.generate_sdl()

# Get schema statistics
stats = SchemaHelpers.schema_stats()

# Validate schema
case SchemaHelpers.validate_schema() do
  :ok -> IO.puts("Schema valid!")
  {:error, errors} -> IO.inspect(errors)
end
```

## Troubleshooting

### Schema Not Found Errors
Make sure your GraphQL schema module is properly configured in `lib/template_phoenix_api_web/schema.ex`.

### Permission Errors
Ensure the `data/` directory is writable and the parent directories exist.

### Schema Validation Failures
Check your GraphQL type definitions for:
- Missing required fields
- Circular dependencies
- Invalid type references
- Malformed resolver functions

### Empty Statistics
If schema statistics show zeros, it usually means:
- Schema compilation errors
- Missing type imports in your main schema module
- Resolver functions not properly defined

Run `mix graphql.schema.validate` to identify specific issues.