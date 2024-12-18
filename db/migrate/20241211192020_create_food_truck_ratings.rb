class CreateFoodTruckRatings < ActiveRecord::Migration[7.2]
  def change
    create_table :food_truck_ratings do |t|
      t.integer :rating
      t.text :review
      t.references :event_application, null: false, foreign_key: true
      t.references :food_truck, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
