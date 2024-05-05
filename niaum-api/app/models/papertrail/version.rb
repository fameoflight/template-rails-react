# frozen_string_literal: true

# == Schema Information
#
# Table name: versions
#
#  id             :bigint           not null, primary key
#  event          :string           not null
#  item_type      :string           not null, indexed => [item_id]
#  metadata       :jsonb
#  object         :jsonb
#  object_changes :jsonb
#  whodunnit      :string
#  created_at     :datetime
#  updated_at     :datetime
#  item_id        :bigint           not null, indexed => [item_type]
#  user_id        :bigint           indexed
#
# Indexes
#
#  index_versions_on_item_type_and_item_id  (item_type,item_id)
#  index_versions_on_user_id                (user_id)
#
# Foreign Keys
#
#  fk_rails_914f13c63b  (user_id => users.id)
#
module Papertrail
  class Version < ApplicationRecord
    include PaperTrail::VersionConcern
    include Papertrail::SquashHelpers

    def self.default_scope_method
      nil
    end

    polymorphic_belongs_to :item

    belongs_to :user, optional: true
    belongs_to :company, optional: true, class_name: 'Hub::Company'

    # Note(hemantv): this can be moved to background job in future
    # to improve performance
    after_create :squash_changes_if_possible

    def squash_changes_if_possible
      unprocessed_versions = self.class.where(
        item:,
        whodunnit:
      ).where('created_at > ?', 15.minutes.ago)

      squash_versions(unprocessed_versions)
    end
  end
end
