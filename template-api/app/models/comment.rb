# == Schema Information
#
# Table name: comments
#
#  id                :bigint           not null, primary key
#  commentable_type  :string           not null, indexed => [commentable_id]
#  discarded_at      :datetime         indexed
#  rating            :decimal(5, 2)
#  rich_text_content :jsonb            not null
#  tags              :string           default([]), is an Array
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  commentable_id    :bigint           not null, indexed => [commentable_type]
#  user_id           :bigint           not null, indexed
#
# Indexes
#
#  index_comments_on_commentable   (commentable_type,commentable_id)
#  index_comments_on_discarded_at  (discarded_at)
#  index_comments_on_user_id       (user_id)
#
# Foreign Keys
#
#  fk_rails_03de2dc08c  (user_id => users.id)
#
class Comment < ApplicationRecord
  include Discard::Model

  belongs_to :commentable, polymorphic: true

  belongs_to :user

  store_attribute :rich_text_content, Stores::RichText

  validates :rating, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }, allow_nil: true

  before_save :sanitize_tags

  validates :commentable_type, inclusion: { in: ['BlogPost'] }

  def sanitize_tags
    self.tags = tags.map(&:downcase)
  end
end
