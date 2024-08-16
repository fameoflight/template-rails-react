# frozen_string_literal: true

module Types
  module Model
    class ModelAttachmentType < Types::BaseModelObject
      setup ModelAttachment, fields: %i[name]

      field :attachment, Types::Model::AttachmentType, null: true
    end
  end
end
