class CreateSuperUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :super_users do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }

      t.references :spoof_user, null: true, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
