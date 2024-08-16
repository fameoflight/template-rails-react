# frozen_string_literal: true

module Types
  module ModelAttachmentInterface
    include Types::BaseInterface
    implements Types::ModelInterface

    field :attachments, [Types::Model::ModelAttachmentType], null: false, method: :model_attachments
  end
end
