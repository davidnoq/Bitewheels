class AddSlugToFoodTrucks < ActiveRecord::Migration[7.2]
  def change
    add_column :food_trucks, :slug, :string
    add_index :food_trucks, :slug, unique: true
  end
end
