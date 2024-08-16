# frozen_string_literal: true

# == Schema Information
#
# Table name: active_storage_attachments
#
#  id          :bigint           not null, primary key
#  name        :string           not null, indexed => [record_type, record_id, blob_id]
#  record_type :string           not null, indexed => [record_id, name, blob_id]
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  blob_id     :bigint           not null, indexed, indexed => [record_type, record_id, name]
#  record_id   :bigint           not null, indexed => [record_type, name, blob_id]
#
# Indexes
#
#  index_active_storage_attachments_on_blob_id  (blob_id)
#  index_active_storage_attachments_uniqueness  (record_type,record_id,name,blob_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_c3b3935057  (blob_id => active_storage_blobs.id)
#
module ActiveStorage
  class ActiveStorageAttachment < ActiveStorage::Attachment
  end
end
