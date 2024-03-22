# This migration adds a default role to the users table in the database
class AddDefaultRoleToUsers < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :role, from: nil, to: 0
  end
end
