# frozen_string_literal: true

module Stores
  class Model
    MAX_BYTESIZE = 5.megabytes

    extend Enumerize
    include StoreModel::Model

    delegate :bytesize, to: :to_json

    class << self
      def model_attribute(name, model_kind, opts = {})
        attribute_name = "#{name}_id"

        attribute attribute_name, :integer, **opts

        define_method(name) do
          if model_kind.is_a?(String)
            model_kind.constantize.find_by(id: send(attribute_name))
          else
            model_kind.find_by(id: send(attribute_name))
          end
        end
      end

      def store_attribute(name, store_type, **kwargs)
        array = kwargs.delete(:array) || false

        # Note(hemantv): store_type must support to_type and to_array_type methods
        attribute_type = array ? store_type.to_array_type : store_type.to_type

        attribute name, attribute_type, **kwargs

        store_model_validation_options = {}

        if array
          store_model_validation_options[:merge_array_errors] = true
        else
          store_model_validation_options[:merge_errors] = true
        end

        validates name, store_model: store_model_validation_options
      end
    end

    validate :validate_bytesize

    def validate_bytesize
      return if bytesize <= MAX_BYTESIZE

      errors.add(:base, "must be less than #{max_bytesize} bytes")
    end

    def to_h
      JSON.parse(to_json, symbolize_names: true).with_indifferent_access
    end

    delegate :to_msgpack, to: :to_h

    def [](key)
      send(key)
    end
  end
end
