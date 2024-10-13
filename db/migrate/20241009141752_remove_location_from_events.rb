class RemoveLocationFromEvents < ActiveRecord::Migration[7.2]
  def change
    remove_column :events, :location, :string
  end
end
