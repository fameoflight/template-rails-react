# frozen_string_literal: true

module Validators
  class HttpUrl < ActiveModel::EachValidator
    def self.compliant?(value)
      uri = URI.parse(value)
      uri.is_a?(URI::HTTP) && !uri.host.nil?
    rescue URI::InvalidURIError
      false
    end

    def validate_each(record, attribute, value)
      record.errors.add(attribute, 'must be a valid http url') unless value.present? && self.class.compliant?(value)
    end
  end
end
