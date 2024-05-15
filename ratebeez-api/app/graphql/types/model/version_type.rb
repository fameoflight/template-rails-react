# frozen_string_literal: true

module Types
  module Model
    class VersionType < Types::BaseModelObject
      setup 'papertrail::version', fields: %i[item_id item_type event metadata whodunnit]

      field :changes, [Types::Model::VersionChangeType], null: false

      field :user, Types::Model::UserType, null: true

      def changes
        object.changeset.to_a
      end
    end
  end
end
