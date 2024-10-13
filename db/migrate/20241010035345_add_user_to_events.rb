# db/migrate/XXXXXXXXXXXXXX_add_user_to_events.rb
class AddUserToEvents < ActiveRecord::Migration[6.1]
  def change
    add_reference :events, :user, null: true, foreign_key: true
  end
end
