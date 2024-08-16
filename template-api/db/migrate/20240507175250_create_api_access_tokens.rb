# frozen_string_literal: true

class CreateApiAccessTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :api_access_tokens do |t|
      t.uuid :uuid, default: 'gen_random_uuid()', null: false

      t.string :name, null: false
      t.string :description

      t.string :token, null: false, index: { unique: true }
      t.references :user, null: false, foreign_key: true

      t.boolean :active, default: true, null: false
      t.datetime :expires_at
      t.datetime :discarded_at, index: true

      t.timestamps
    end
  end
end
