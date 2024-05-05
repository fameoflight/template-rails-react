# frozen_string_literal: true

module Types
  class BaseField < GraphQL::Schema::Field
    include Helpers::ModelArgument
    include Helpers::EnumHelpers

    argument_class Types::BaseArgument
  end
end
