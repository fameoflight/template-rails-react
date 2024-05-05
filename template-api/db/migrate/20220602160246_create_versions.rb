# frozen_string_literal: true

# This migration creates the `versions` table, the only schema PT requires.
# All other migrations PT provides are optional.
class CreateVersions < ActiveRecord::Migration[7.0]
  def change
    create_table :versions do |t|
      t.string   :item_type, null: false
      t.bigint   :item_id,   null: false
      t.string   :event,     null: false
      t.jsonb    :object
      t.jsonb    :object_changes

      t.jsonb    :metadata

      t.string   :whodunnit

      t.datetime :created_at
      t.datetime :updated_at # for graphql later on

      t.references :user, foreign_key: true, null: true
    end
    add_index :versions, %i[item_type item_id]
  end
end
