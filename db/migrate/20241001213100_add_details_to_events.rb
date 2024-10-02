class AddDetailsToEvents < ActiveRecord::Migration[7.2]
  def change
    add_column :events, :location, :string
    add_column :events, :expected_attendees, :integer
    add_column :events, :logo, :string
    add_column :events, :foodtruck_amount, :integer
  end
end
