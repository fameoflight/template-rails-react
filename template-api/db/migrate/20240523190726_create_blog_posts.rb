# frozen_string_literal: true

class CreateBlogPosts < ActiveRecord::Migration[7.0]
  def change
    create_table :blog_posts do |t|
      t.citext :short_id, null: false, index: { unique: true }
      t.string :title, null: false
      t.jsonb :rich_text_content, null: false, default: {}
      t.string :tags, array: true, default: [], null: false
      t.citext :status, null: false, default: 'draft', index: true
      t.datetime :published_at, null: true

      t.timestamps
    end

    add_index :blog_posts, :tags, using: 'gin'
  end
end
