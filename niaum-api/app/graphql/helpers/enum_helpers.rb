# frozen_string_literal: true

module Helpers
  module EnumHelpers
    extend ActiveSupport::Concern

    def enum_argument(name, values:, **kwargs)
      # NOTE: graphql_name come from parent field
      gql_name = "#{graphql_name}#{name.to_s.camelize}Enum"

      values = values.call if values.is_a?(Proc)

      values = values.clone

      values <<= kwargs[:default_value] if kwargs[:default_value]

      enum_klass = enum_class(gql_name, values)

      enum_klass = [enum_klass] if kwargs.delete(:array)

      argument name, enum_klass, **kwargs
    end

    def enum_field(name, values:, **kwargs)
      null = kwargs.delete(:null) || false

      array = kwargs.delete(:array) || false

      # NOTE: graphql_name come from parent field
      gql_name = "#{graphql_name}#{name.to_s.classify}Enum"

      enum_klass = enum_class(gql_name, values)

      enum_klass = [enum_klass] if array

      field name, enum_klass, null:
    end

    def enum_class(gql_name, ruby_values)
      uniq_values = ruby_values.flatten.compact.map(&:to_s).uniq

      Class.new(Types::BaseEnum) do
        graphql_name gql_name

        uniq_values.each do |v|
          value(v, value: v)
        end
      end
    end
  end
end
