# frozen_string_literal: true

module Types
  module Model
    class VersionChangeType < Types::BaseObject
      field :label, String, null: false

      field :new_value, String, null: true
      field :previous_value, String, null: true

      def label
        object[0]
      end

      def previous_value
        object[1][0]
      end

      def new_value
        object[1][1]
      end
    end
  end
end
