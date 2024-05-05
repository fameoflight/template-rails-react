# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.jsonb :rich_text_content, null: false
      t.references :commentable, polymorphic: true, null: false
      t.references :user, null: false, foreign_key: true
      t.string :tags, array: true, default: []
      t.decimal :rating, precision: 5, scale: 2

      t.datetime :discarded_at, index: true

      t.timestamps
    end
  end
end
