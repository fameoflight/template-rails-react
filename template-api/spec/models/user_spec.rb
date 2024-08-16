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
require 'rails_helper'

RSpec.describe User, type: :model do
  it 'test creation' do
    expect do
      described_class.create!(
        name: 'Test',
        email: 'test@test.com',
        password: 'testtest'
      )
    end.to change(described_class, :count).by(1)
  end
end
