# frozen_string_literal: true

class DeviseTokenAuthCreateUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :tokens, :jsonb, default: {}
    add_column :users, :provider, :citext, null: false, default: 'email'
    add_column :users, :uid, :citext, null: false, default: ''

    # for two factor authentication
    add_column :users, :otp_secret, :string

    add_index :users, %i[uid provider email], unique: true
  end
end
