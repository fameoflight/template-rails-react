# frozen_string_literal: true

module Types
  module Model
    class AttachmentType < Types::BaseModelObject
      include Helpers::ActiveStorage

      setup ActiveStorage::ActiveStorageAttachment, fields: %i[name record_id record_type]

      field :content_type, String, null: true

      field :url, String, null: true

      def url
        attachment_url(object)
      end

      def content_type
        object.content_type if object.attached?
      end
    end
  end
end
