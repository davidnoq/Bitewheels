class CreateEventApplications < ActiveRecord::Migration[7.2]
  def change
    create_table :event_applications do |t|
      t.references :food_truck, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.integer :status, default: 0, null: false

      t.timestamps
    end

    # Ensure a food truck can apply only once per event
    add_index :event_applications, [:food_truck_id, :event_id], unique: true
  end
end
