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
require 'rails_helper'

RSpec.describe Notification, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
