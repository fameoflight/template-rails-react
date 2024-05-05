# frozen_string_literal: true

class AddPgCrypto < ActiveRecord::Migration[7.0]
  def change
    ActiveRecord::Base.connection.execute <<-SQL.squish
      CREATE extension IF NOT EXISTS pgcrypto;
    SQL

    ActiveRecord::Base.connection.execute <<-SQL.squish
      CREATE EXTENSION IF NOT EXISTS citext;
    SQL
  end
end
