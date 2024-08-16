# frozen_string_literal: true

# Helpful Guide
# https://evilmartians.com/chronicles/active-storage-meets-graphql-direct-uploads

module Mutations
  class DirectUploadType < Types::BaseObject
    field :id, String, null: false
    field :signed_id, String, null: false

    field :filename, String, null: false

    field :direct_upload_headers, GraphQL::Types::JSON, null: false, method: :service_headers_for_direct_upload
    field :direct_upload_url, String, null: false, method: :service_url_for_direct_upload
    field :public_url, String, null: false

    def public_url
      Rails.application.routes.url_helpers.rails_blob_url(object, host: context[:host])
    end
  end

  class CreateDirectUpload < Mutations::BaseMutation
    def self.authorized?(_object, context)
      user_context = context[:user_context]

      super && user_context.current_user.present?
    end

    def ready?(**kwargs)
      byte_size = kwargs[:byte_size]

      content_type = kwargs[:content_type]

      return [false, { errors: ['File size is too large'] }] if byte_size > user_context.file_size_limit

      return [false, { errors: ['File type is not allowed'] }] unless user_context.file_type_allowed?(content_type)

      true
    end

    argument :byte_size, Int, required: true
    argument :checksum, String, required: true
    argument :content_type, String, required: true
    argument :filename, String, required: true

    field :direct_upload, DirectUploadType, null: false

    def run(**kwargs)
      blob = ActiveStorage::Blob.new(
        filename: kwargs[:filename],
        byte_size: kwargs[:byte_size],
        checksum: kwargs[:checksum],
        content_type: kwargs[:content_type],
        metadata: {
          ip: context[:ip],
          user_id: user_context.current_user.id
        }
      )

      if blob.save
        {
          direct_upload: blob,
          errors: []
        }
      else
        {
          direct_upload: nil,
          errors: blob.errors.full_messages
        }
      end
    end
  end
end
