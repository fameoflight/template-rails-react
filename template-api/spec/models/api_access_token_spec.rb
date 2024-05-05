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
require 'rails_helper'

RSpec.describe ApiAccessToken, type: :model do
  it 'set token before create' do
    api_access_token = create(:api_access_token)

    expect(api_access_token.token).to be_present
  end

  it 'validates name presence' do
    api_access_token = build(:api_access_token, name: nil)

    expect(api_access_token).not_to be_valid
    expect(api_access_token.errors[:name]).to include("can't be blank")
  end

  it 'validates user presence' do
    api_access_token = build(:api_access_token, user: nil)

    expect(api_access_token).not_to be_valid
    expect(api_access_token.errors[:user]).to include('must exist')
  end

  describe '#active?' do
    it 'returns true if expires_at is nil' do
      api_access_token = build(:api_access_token, expires_at: nil, active: true)

      expect(api_access_token.active?).to be(true)
    end

    it 'returns true if expires_at is in the future' do
      api_access_token = build(:api_access_token, expires_at: 1.day.from_now, active: true)

      expect(api_access_token.active?).to be(true)
    end

    it 'returns false if expires_at is in the past' do
      api_access_token = build(:api_access_token, expires_at: 1.day.ago, active: true)

      expect(api_access_token.active?).to be(false)
    end

    it 'returns false if active is false' do
      api_access_token = build(:api_access_token, expires_at: 1.day.from_now, active: false)

      expect(api_access_token.active?).to be(false)
    end

    it 'returns false if discarded' do
      api_access_token = build(:api_access_token, expires_at: 1.day.from_now, active: true)

      api_access_token.discard

      expect(api_access_token.active?).to be(false)
    end
  end

  describe 'discard' do
    it 'discards the record' do
      api_access_token = create(:api_access_token)

      api_access_token.discard

      expect(api_access_token.discarded?).to be(true)
    end

    it 'returns discarded records' do
      api_access_token = create(:api_access_token)

      api_access_token.discard

      expect(described_class.discarded).to include(api_access_token)
    end

    it 'find discarded records' do
      api_access_token = create(:api_access_token)

      api_access_token.discard

      expect(described_class.find(api_access_token.id)).to eq(api_access_token)
    end
  end
end
