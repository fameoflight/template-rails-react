# == Schema Information
#
# Table name: notifications
#
#  id                :bigint           not null, primary key
#  data              :json
#  message           :text
#  notification_type :string
#  read_at           :datetime
#  title             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  user_id           :bigint           not null, indexed
#
# Indexes
#
#  index_notifications_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_b080fb4855  (user_id => users.id)
#
FactoryBot.define do
  factory :notification do
    user { nil }
    title { "MyString" }
    message { "MyText" }
    notification_type { "MyString" }
    read_at { "2025-07-29 16:26:44" }
    data { "" }
  end
end
