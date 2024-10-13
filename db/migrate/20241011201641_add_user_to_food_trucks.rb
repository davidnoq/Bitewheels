class AddUserToFoodTrucks < ActiveRecord::Migration[7.2]
  def change
    add_reference :food_trucks, :user, null: false, foreign_key: true
  end
end
