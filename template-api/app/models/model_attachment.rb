# frozen_string_literal: true

# == Schema Information
#
# Table name: model_attachments
#
#  id           :bigint           not null, primary key
#  discarded_at :datetime         indexed
#  metadata     :jsonb            not null
#  name         :string           not null
#  owner_type   :string           not null, indexed => [owner_id]
#  uuid         :uuid             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  owner_id     :bigint           not null, indexed => [owner_type]
#
# Indexes
#
#  index_model_attachments_on_discarded_at  (discarded_at)
#  index_model_attachments_on_owner         (owner_type,owner_id)
#
class ModelAttachment < ApplicationRecord
  include ModelFreezeable
  include Discard::Model

  has_one_attached :attachment

  polymorphic_belongs_to :owner, in: %i[User]

  freeze_columns %i[owner_type owner_id], if: -> { !new_record? }

  after_save :notify_owner

  def notify_owner
    owner.after_attachment_create(self)
  end
end
