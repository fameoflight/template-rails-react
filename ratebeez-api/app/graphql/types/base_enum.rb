# frozen_string_literal: true

module Types
  class BaseEnum < GraphQL::Schema::Enum
    def self.value(*args, **kwargs, &)
      kwargs[:value] = kwargs[:value].to_s if kwargs[:value].is_a?(Symbol)

      super
    end
  end
end
