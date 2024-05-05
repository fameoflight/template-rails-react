# frozen_string_literal: true

class EnableCitext < ActiveRecord::Migration[7.0]
  def up
    enable_extension 'citext'
  end

  def down
    change_column :user, :name, :string
  end
end
