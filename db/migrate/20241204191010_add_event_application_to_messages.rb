class AddEventApplicationToMessages < ActiveRecord::Migration[7.2]
  def change
    add_reference :messages, :event_application, null: false, foreign_key: true
  end
end
