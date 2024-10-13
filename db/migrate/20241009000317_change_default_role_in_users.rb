# db/migrate/20241008235134_change_default_role_in_users.rb
class ChangeDefaultRoleInUsers < ActiveRecord::Migration[7.2]
  def change
    change_column_default :users, :role, from: "0", to: "user"
  end
end
