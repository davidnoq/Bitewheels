class AddOrganizerIdToEvents < ActiveRecord::Migration[7.2]
  def change
    add_column :events, :organizer_id, :integer
  end
end
