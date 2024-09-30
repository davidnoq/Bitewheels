class RenameAmountFoodtrucksInEvents < ActiveRecord::Migration[7.2]
  def change
    rename_column :events, :amount_foodtrucks, :amount_of_food_trucks
  end
end
