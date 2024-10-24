class CreateFoodTrucks < ActiveRecord::Migration[7.2]
  def change
    create_table :food_trucks do |t|
      t.string :name
      t.string :cuisine
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
