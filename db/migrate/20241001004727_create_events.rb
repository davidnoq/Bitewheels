class CreateEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.datetime :start_date
      t.datetime :end_date
      t.integer :expected_attendees
      t.string :logo
      t.integer :foodtruck_amount
      t.string :address
      t.float :latitude
      t.float :longitude
      t.integer :status, default: 0, null: false
      t.references :user, null: true, foreign_key: true
      
      t.timestamps
    end
    add_column :events, :credit_cost, :integer, default: 3, null: false
    add_column :events, :accepting_applications, :boolean, default: true, null: false
    add_column :events, :approved_applications_count, :integer, default: 0, null: false
    add_column :events, :searching_for_cuisine, :string
  end
end
