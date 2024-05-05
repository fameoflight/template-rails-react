# frozen_string_literal: true

module Helpers
  module ModelArgument
    extend ActiveSupport::Concern

    def model_argument(name, graphql_type, **)
      prepare = proc { |id, ctx|
        _prepare_value(graphql_type, id, ctx)
      }

      argument("#{name.to_s.underscore}_id", GraphQL::Types::ID, prepare:, as: name, **)
    end

    def model_array_argument(name, graphql_type, **)
      argument_name = "#{name.to_s.singularize.underscore}_ids"

      prepare = proc { |ids, ctx|
        ids&.map do |id|
          _prepare_value(graphql_type, id, ctx)
        end
      }

      argument(argument_name, [GraphQL::Types::ID], prepare:, as: name, **)
    end

    def attachment_argument(name, **)
      argument_name = "#{name}_signed_id"

      argument(argument_name, String, 'Signed blob ID generated via `createDirectUpload` mutation', **, as: name)
    end

    def _prepare_value(graphql_type, id, ctx)
      return id if id == NULL_MARKER || id.nil?

      # if it's not a model then it's a ID
      node_object = ctx.schema.object_from_id(id, nil)

      node_object.tap do |object|
        if graphql_type
          unless object.is_a?(graphql_type.model)
            raise GraphQL::ExecutionError,
                  "Invalid ID: #{id}, expected #{graphql_type.model}, got #{object.class}"
          end
        end
      end
    end
  end
end
