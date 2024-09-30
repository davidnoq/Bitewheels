class AddNameToFoodTrucks < ActiveRecord::Migration[7.2]
  def change
    add_column :food_trucks, :name, :string
  end
end
