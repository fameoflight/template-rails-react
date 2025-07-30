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
class Message < ApplicationRecord
  include ModelGraphqlable

  belongs_to :user

  validates :content, presence: true
  validates :room_id, presence: true

  scope :for_room, ->(room_id) { where(room_id: room_id) }
  scope :recent, -> { order(created_at: :desc) }

  def graphql_class
    'Types::MessageType'
  end
end
