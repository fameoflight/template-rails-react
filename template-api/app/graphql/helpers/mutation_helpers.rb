# frozen_string_literal: true

module Helpers
  module MutationHelpers
    extend ActiveSupport::Concern

    class_methods do
      def scope_mutation_field(name, mutation_type)
        field(name, mutation_type, null: false)
        define_method(name) do
          name
        end
      end
    end
  end
end
