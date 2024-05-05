# frozen_string_literal: true

# :nocov:
# == Schema Information
#
# Table name: active_storage_variant_records
#
#  id               :bigint           not null, primary key
#  variation_digest :string           not null, indexed => [blob_id]
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  blob_id          :bigint           not null, indexed => [variation_digest]
#
# Indexes
#
#  index_active_storage_variant_records_uniqueness  (blob_id,variation_digest) UNIQUE
#
# Foreign Keys
#
#  fk_rails_993965df05  (blob_id => active_storage_blobs.id)
#
module ActiveStorage
  class ActiveStorageVariantRecord < ActiveStorage::VariantRecord
  end
end
