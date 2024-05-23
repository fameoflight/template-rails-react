# == Schema Information
#
# Table name: blog_posts
#
#  id                :bigint           not null, primary key
#  published_at      :datetime
#  rich_text_content :jsonb            not null
#  status            :citext           default("draft"), not null, indexed
#  tags              :string           default([]), not null, is an Array, indexed
#  title             :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  short_id          :citext           not null, indexed
#
# Indexes
#
#  index_blog_posts_on_short_id  (short_id) UNIQUE
#  index_blog_posts_on_status    (status)
#  index_blog_posts_on_tags      (tags) USING gin
#
class BlogPost < ApplicationRecord
  has_paper_trail(
    versions: {
      class_name: 'Papertrail::Version'
    }
  )

  enumerize :status, in: %i[draft published], default: :draft, predicates: true

  validates :short_id, presence: true, uniqueness: true

  validates :title, presence: true

  store_attribute :rich_text_content, Stores::RichText

  before_validation :generate_short_id, on: :create
  before_validation :normalize_tags
  before_save :set_published_at

  has_many :comments, as: :commentable, dependent: :destroy

  private

  def normalize_tags
    self.tags = tags.map { |tag| tag.downcase.strip }.uniq
  end

  def set_published_at
    self.published_at = Time.current if published? && published_at.blank?
  end

  def generate_short_id
    return if short_id.present?

    self.short_id = title.parameterize
  end
end
