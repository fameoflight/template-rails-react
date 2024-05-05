# frozen_string_literal: true

module Mutations
  class MutationType < Types::BaseObject
    include Helpers::MutationHelpers

    field :user_otp_update, mutation: Mutations::Model::UserOtpUpdate
    field :user_update, mutation: Mutations::Model::UserUpdate

    field :destroy_object, mutation: Mutations::DestroyObject

    field :discard_object, mutation: Mutations::DiscardObject

    field :super_user_update, mutation: Mutations::Model::SuperUserUpdate

    field :create_direct_upload, mutation: Mutations::CreateDirectUpload

    field :model_attachment_create_update, mutation: Mutations::Model::ModelAttachmentCreateUpdate
  end
end
