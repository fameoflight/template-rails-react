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
class Notification < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :message, presence: true
  validates :notification_type, presence: true

  scope :unread, -> { where(read_at: nil) }
  scope :read, -> { where.not(read_at: nil) }
  scope :recent, -> { order(created_at: :desc) }

  TYPES = %w[
    message
    system
    achievement
    reminder
    update
    warning
    error
    success
  ].freeze

  validates :notification_type, inclusion: { in: TYPES }

  def read?
    read_at.present?
  end

  def unread?
    !read?
  end

  def mark_as_read!
    update!(read_at: Time.current)
  end

  def icon
    case notification_type
    when 'message' then 'message'
    when 'system' then 'system'
    when 'achievement' then 'trophy'
    when 'reminder' then 'clock'
    when 'update' then 'sync'
    when 'warning' then 'warning'
    when 'error' then 'close-circle'
    when 'success' then 'check-circle'
    else 'bell'
    end
  end

  def color
    case notification_type
    when 'message' then 'blue'
    when 'system' then 'gray'
    when 'achievement' then 'gold'
    when 'reminder' then 'orange'
    when 'update' then 'cyan'
    when 'warning' then 'orange'
    when 'error' then 'red'
    when 'success' then 'green'
    else 'blue'
    end
  end
end
