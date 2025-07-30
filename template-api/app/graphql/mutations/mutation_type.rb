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

    field :api_access_token_create_update, mutation: Mutations::Model::ApiAccessTokenCreateUpdate

    field :comment_create_update, mutation: Mutations::Model::CommentCreateUpdate

    field :message_create, mutation: Mutations::MessageCreate

    field :notification_mark_as_read, mutation: Mutations::NotificationMarkAsRead
    field :notification_mark_all_as_read, mutation: Mutations::NotificationMarkAllAsRead
  end
end
