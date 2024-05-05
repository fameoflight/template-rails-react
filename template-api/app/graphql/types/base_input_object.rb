# frozen_string_literal: true

module Types
  class BaseInputObject < GraphQL::Schema::InputObject
    extend Helpers::EnumHelpers

    argument_class Types::BaseArgument
  end
end
