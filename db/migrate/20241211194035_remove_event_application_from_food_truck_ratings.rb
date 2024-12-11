class RemoveEventApplicationFromFoodTruckRatings < ActiveRecord::Migration[7.2]
  def change
    remove_reference :food_truck_ratings, :event_application, null: false, foreign_key: true
  end
end
