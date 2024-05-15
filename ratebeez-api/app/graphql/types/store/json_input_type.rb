# frozen_string_literal: true

module Types
  module Store
    class JsonInputType < GraphQL::Types::JSON
      graphql_name 'StoreJsonInput'

      description 'Untyped JSON Input used for Store Model'

      def self.coerce_input(input_value, context)
        input_value.deep_transform_keys! { |key| key.to_s.underscore } if input_value.is_a?(Hash)

        input_value = input_value.map { |item| coerce_input(item, context) } if input_value.is_a?(Array)

        input_value
      end

      def self.coerce_result(ruby_value, _context)
        ruby_value.deep_transform_keys! { |key| key.to_s.camelize(:lower) }
      end
    end
  end
end
