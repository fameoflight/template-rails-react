# frozen_string_literal: true

# == Schema Information
#
# Table name: super_users
#
#  id            :bigint           not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  spoof_user_id :bigint           indexed
#  user_id       :bigint           not null, indexed
#
# Indexes
#
#  index_super_users_on_spoof_user_id  (spoof_user_id)
#  index_super_users_on_user_id        (user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_519620417f  (spoof_user_id => users.id)
#  fk_rails_73ce2c8737  (user_id => users.id)
#
class SuperUser < ApplicationRecord
  belongs_to :user

  belongs_to :spoof_user, class_name: 'User', optional: true

  validates :user_id, uniqueness: true
end
