class CreateEventOrganizers < ActiveRecord::Migration[7.2]
  def change
    create_table :event_organizers do |t|
      t.string :name
      t.integer :user_id

      t.timestamps
    end
  end
end
