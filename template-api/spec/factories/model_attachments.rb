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
FactoryBot.define do
  factory :model_attachment do
    owner { create(:user) }
    name { Faker::Lorem.word }
    metadata { { 'key' => 'value' } }
  end
end
