# frozen_string_literal: true

class NiaumApiSchema < GraphQL::Schema
  extend Helpers::EncryptIds
  use GraphQL::Dataloader

  query(Types::QueryType)
  mutation(Mutations::MutationType)

  max_query_string_tokens(5000)

  validate_max_errors(100)

  max_depth(15)

  max_complexity(1000)

  def self.resolve_type(_abstract_type, obj, _ctx)
    graphql_class = obj.try(:graphql_class)

    graphql_class = graphql_class.safe_constantize if graphql_class.is_a? String

    graphql_class
  end

  def self.id_from_object(object, type_definition, _query_ctx)
    encrypted_object_id(object, type_definition)
  end

  def self.object_from_id(encrypted_id_with_hints, _query_ctx)
    object_from_encrypted_id(encrypted_id_with_hints)
  end

  def self.unauthorized_object(error)
    raise GraphQL::ExecutionError, "An object of type #{error.type.graphql_name} was hidden due to permissions"
  end

  # GraphQL-Ruby calls this when something goes wrong while running a query:
  def self.type_error(err, context)
    Rails.logger.error(err)
    # if err.is_a?(GraphQL::InvalidNullError)
    #   # report to your bug tracker here
    #   return nil
    # end
    super
  end
end
