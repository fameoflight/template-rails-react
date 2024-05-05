# frozen_string_literal: true

class CreateModelAttachments < ActiveRecord::Migration[7.0]
  def change
    create_table :model_attachments do |t|
      t.uuid :uuid, default: 'gen_random_uuid()', null: false
      t.string :name, null: false
      t.references :owner, null: false, polymorphic: true
      t.jsonb :metadata, default: {}, null: false

      t.datetime :discarded_at, index: true

      t.timestamps
    end
  end
end
