# frozen_string_literal: true

module Validators
  class ScalarHash < ActiveModel::EachValidator
    SCALAR_VALUE_CLASSES = [TrueClass, FalseClass, NilClass, String, Numeric].freeze

    def self.scalar?(value)
      SCALAR_VALUE_CLASSES.any? { |klass| value.is_a?(klass) }
    end

    delegate :scalar?, to: :class

    def validate_each(record, attribute, value)
      unless value.is_a?(Hash)
        record.errors.add(attribute, 'must be a hash')
        return
      end

      value.each do |k, v|
        record.errors.add(attribute, 'keys must be strings or symbols') unless k.is_a?(String) || k.is_a?(Symbol)

        record.errors.add(attribute, 'values must be scalar') unless scalar?(v)
      end
    end
  end
end
