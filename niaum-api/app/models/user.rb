# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  allow_password_change  :boolean          default(TRUE), not null
#  confirm_on_sign_in     :boolean          default(FALSE), not null
#  confirmation_sent_at   :datetime
#  confirmation_token     :string           indexed
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :citext           default(""), not null, indexed, indexed => [uid, provider]
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  invite_code            :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  locked_at              :datetime
#  name                   :string
#  nickname               :string
#  otp_secret             :string
#  provider               :citext           default("email"), not null, indexed => [uid, email]
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string           indexed
#  sign_in_count          :integer          default(0), not null
#  tokens                 :jsonb
#  uid                    :citext           default(""), not null, indexed => [provider, email]
#  unconfirmed_email      :citext
#  unlock_token           :string           indexed
#  uuid                   :uuid             not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token          (confirmation_token) UNIQUE
#  index_users_on_email                       (email) UNIQUE
#  index_users_on_reset_password_token        (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider_and_email  (uid,provider,email) UNIQUE
#  index_users_on_unlock_token                (unlock_token) UNIQUE
#
class User < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search_by, against: %w[name email]

  has_one_attached :avatar
  encrypts :otp_secret, deterministic: false

  devise :database_authenticatable, :async, :registerable, :recoverable, :trackable, :validatable, :rememberable, :confirmable
  # ordering is important here, concern should be after devise
  include DeviseTokenAuth::Concerns::User

  # validates :avatar, presence: true, allow_blank: true, blob: { content_type: :image, size_range: 1..(5.megabytes) }

  def first_name
    name&.split&.first || nickname || 'User'
  end

  def otp_enabled?
    otp_secret.present?
  end

  def valid_otp?(otp)
    return true unless otp_enabled?

    return false if otp.blank?

    ROTP::TOTP.new(otp_secret).verify(otp, drift_behind: 30, drift_ahead: 30)
  end

  def valid_password?(password)
    base64decoded = Base64.decode64(password)

    password_json = JSON.parse(base64decoded)

    assert password_json['password'], 'password is required in the payload'

    if valid_otp?(password_json['otp'])
      super(password_json['password'])
    else
      false
    end
  rescue ArgumentError, JSON::ParserError
    if otp_enabled?
      false
    else
      super(password)
    end
  end
end
