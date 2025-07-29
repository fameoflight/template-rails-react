defmodule TemplatePhoenixApiWeb.Schema do
  use Absinthe.Schema

  alias TemplatePhoenixApiWeb.Schema.Types
  alias TemplatePhoenixApiWeb.Helpers.EncryptIds

  # Import scalar types
  import_types Types.Scalars
  
  # Import interfaces
  import_types Types.Node
  import_types Types.ModelInterface
  import_types Types.AdditionalInterfaces
  
  # Import main types
  import_types Types.User
  import_types Types.Auth
  import_types Types.PlaceholderTypes
  import_types Types.ExtendedQueries
  import_types Types.ExtendedMutations

  query name: "Query" do
    import_fields :user_queries
    import_fields :auth_queries
    import_fields :extended_queries
  end

  mutation name: "Mutation" do
    import_fields :auth_mutations
    import_fields :extended_mutations
  end

  def context(ctx) do
    loader = Dataloader.new()
    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  # ID encoding/decoding functions (similar to Rails GraphQL)
  def id_from_object(object, type, _context) do
    EncryptIds.encrypted_object_id(object, type)
  end

  def object_from_id(id, _context) do
    EncryptIds.object_from_encrypted_id(id)
  end
end