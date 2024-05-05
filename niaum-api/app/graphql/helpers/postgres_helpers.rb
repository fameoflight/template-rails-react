# frozen_string_literal: true

module Helpers
  module PostgresHelpers
    extend ActiveSupport::Concern

    class_methods do
      def convert_db_type(column)
        array = column.sql_type_metadata.sql_type.include?('[]')

        graphql_type = database_type_to_graphql_type(column.type)

        if array
          [graphql_type]
        else
          graphql_type
        end
      end

      def database_type_to_graphql_type(database_type)
        case database_type
        when :integer, :number
          GraphQL::Types::Int
        when :decimal
          GraphQL::Types::Float
        when :boolean
          GraphQL::Types::Boolean
        when :date
          GraphQL::Types::ISO8601Date
        when :datetime
          GraphQL::Types::ISO8601DateTime
        when :json, :jsonb
          GraphQL::Types::JSON
        else
          GraphQL::Types::String
        end
      end
    end
  end
end
