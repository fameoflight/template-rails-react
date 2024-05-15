# frozen_string_literal: true

# == Schema Information
#
# Table name: api_access_tokens
#
#  id           :bigint           not null, primary key
#  active       :boolean          default(TRUE), not null
#  description  :string
#  discarded_at :datetime         indexed
#  expires_at   :datetime
#  name         :string           not null
#  token        :string           not null, indexed
#  uuid         :uuid             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null, indexed
#
# Indexes
#
#  index_api_access_tokens_on_discarded_at  (discarded_at)
#  index_api_access_tokens_on_token         (token) UNIQUE
#  index_api_access_tokens_on_user_id       (user_id)
#
# Foreign Keys
#
#  fk_rails_f405a7988d  (user_id => users.id)
#
class ApiAccessToken < ApplicationRecord
  include Discard::Model
  belongs_to :user, optional: false

  validates :name, presence: true

  encrypts :token, deterministic: true

  before_create :create_token

  # TODO: placeholder for testing
  has_many :comments, as: :commentable, dependent: :destroy # remove when not needed

  def create_token
    return if token.present?

    prefix = Rails.env.production? ? 'prod' : 'dev'

    random_string = SecureRandom.hex(32)

    self.token = "#{prefix}_#{random_string}"
  end

  def active?
    return false if discarded?
    return false if expires_at.present? && expires_at < Time.current

    active
  end
end
