# frozen_string_literal: true

# :nocov:

# == Schema Information
#
# Table name: active_storage_blobs
#
#  id           :bigint           not null, primary key
#  byte_size    :bigint           not null
#  checksum     :string
#  content_type :string
#  filename     :string           not null
#  key          :string           not null, indexed
#  metadata     :text
#  service_name :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_active_storage_blobs_on_key  (key) UNIQUE
#
module ActiveStorage
  class ActiveStorageBlob < ActiveStorage::Blob
  end
end
