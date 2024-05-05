# frozen_string_literal: true

module Types
  module Model
    class SuperUserType < Types::BaseModelObject
      def self.authorized?(object, context)
        user_context = context[:user_context]

        super && user_context.super?
      end

      setup :user, fields: %i[name]

      field :users, [Types::Model::UserType], null: false do
        argument :term, String, required: false, default_value: nil
      end

      field :versions, [Types::Model::VersionType], null: false do
        argument :item_id, ID, required: true
        argument :item_type, String, required: true
      end

      field :job_records, [Types::Model::JobRecordType], null: false

      def users(term:)
        query = User.all if term.blank?

        query = User.search_by(term) if term.present?

        query.last(100)
      end

      def versions(item_id:, item_type:)
        Papertrail::Version.where(item_id:, item_type:).last(100)
      end

      def job_records
        JobRecord.last(100)
      end
    end
  end
end
