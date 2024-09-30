class RemoveStartDateAndEndDateFromEvents < ActiveRecord::Migration[7.2]
  def change
    remove_column :events, :start_date, :datetime
    remove_column :events, :end_date, :datetime
  end
end
