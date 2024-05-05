# frozen_string_literal: true

module Types
  module Store
    class BaseType < Types::BaseObject
      class << self
        attr_reader :store_class

        def setup(store_class)
          @store_class = store_class
          @store_class = @store_class.constantize if @store_class.is_a?(String)
        end

        def enum_field(name, **kwargs)
          values = kwargs.delete(:values)
          values ||= @store_class.send(name).values

          super(name, values:, **kwargs)
        end

        def model_field(name, graphql_type, **kwargs)
          field(name, graphql_type, **kwargs)

          define_method(name) do
            graphql_type.model.find_by(id: object.send(:"#{name}_id"))
          end
        end
      end
    end
  end
end
