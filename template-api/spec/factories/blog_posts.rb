# frozen_string_literal: true

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
FactoryBot.define do
  factory :blog_post do
    title { 'First Post' }
    rich_text_content do
      {
        format: 'markdown',
        content: '{}',
        content_markdown: 'This is my first post.'
      }
    end
  end
end
