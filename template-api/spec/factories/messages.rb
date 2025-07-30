# == Schema Information
#
# Table name: messages
#
#  id         :bigint           not null, primary key
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  room_id    :string
#  user_id    :bigint           not null, indexed
#
# Indexes
#
#  index_messages_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_273a25a7a6  (user_id => users.id)
#
FactoryBot.define do
  factory :message do
    content { "MyText" }
    user { nil }
    room_id { "MyString" }
  end
end
