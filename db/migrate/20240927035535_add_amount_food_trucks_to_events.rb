class AddAmountFoodTrucksToEvents < ActiveRecord::Migration[7.2]
  def change
    add_column :events, :amount_foodtrucks, :integer
  end
end
