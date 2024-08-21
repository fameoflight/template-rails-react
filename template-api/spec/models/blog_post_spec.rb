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
require 'rails_helper'

RSpec.describe BlogPost, type: :model do
  it 'has a valid factory' do
    expect(build(:blog_post)).to be_valid
  end

  describe 'tags' do
    it 'normalizes tags' do
      blog_post = create(:blog_post, tags: ['Ruby', '  RAILS', 'ruby'])

      expect(blog_post.tags).to eq(%w[ruby rails])
    end

    it 'removes duplicates' do
      blog_post = create(:blog_post, tags: %w[Ruby Ruby])

      expect(blog_post.tags).to eq(['ruby'])
    end

    it 'downcases tags' do
      blog_post = create(:blog_post, tags: ['Ruby'])

      expect(blog_post.tags).to eq(['ruby'])
    end
  end

  describe 'rich_text_content' do
    it 'validates format is required' do
      blog_post = build(:blog_post, rich_text_content: { content: 'invalid' })

      expect(blog_post).not_to be_valid
      expect(blog_post.errors[:rich_text_content]).to eq(["Format can't be blank", 'Format is not included in the list'])
    end
  end

  describe 'versioning' do
    it 'creates a version when created' do
      with_versioning do
        blog_post = create(:blog_post)

        expect(blog_post.versions.count).to eq(1)
      end
    end

    it 'creates a version when updated' do
      with_versioning do
        blog_post = create(:blog_post)

        blog_post.update!(title: 'New Title')

        expect(blog_post.versions.count).to eq(1) # they get squashed
      end
    end
  end
end
