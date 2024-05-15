# frozen_string_literal: true

module Types
  module Store
    class BaseInputObject < Types::BaseInputObject
      class << self
        attr_reader :store_class

        def setup(store_class)
          @store_class = store_class
          @store_class = @store_class.constantize if @store_class.is_a?(String)
        end

        def enum_argument(name, **kwargs)
          values = kwargs.delete(:values)
          values ||= @store_class.send(name).values

          super(name, values:, **kwargs)
        end

        def model_argument(name, **kwargs)
          argument "#{name}_model_id", GraphQL::Types::Int, as: "#{name}_id", **kwargs
        end
      end

      def prepare
        to_h.deep_transform_keys! { |key| key.to_s.underscore.to_sym }
      end
    end
  end
end
