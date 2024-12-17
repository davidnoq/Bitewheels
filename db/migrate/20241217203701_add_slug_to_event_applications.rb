class AddSlugToEventApplications < ActiveRecord::Migration[7.2]
  def change
    add_column :event_applications, :slug, :string
    add_index :event_applications, :slug, unique: true
  end
end
