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
FactoryBot.define do
  factory :api_access_token do
    name { 'FactoryBot API Access Token' }
    description { 'FactoryBot API Access Token Description' }
    user { create(:user) }
  end
end
