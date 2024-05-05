# frozen_string_literal: true

module Stores
  module CustomTypes
    class StringArray < ActiveRecord::Type::Value
      # Example:
      #         attribute :messages, Stores::CustomTypes::StringArray.new, default: -> { [] }

      def type
        :string_array
      end
    end
  end
end
