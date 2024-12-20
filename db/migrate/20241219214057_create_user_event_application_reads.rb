class CreateUserEventApplicationReads < ActiveRecord::Migration[7.2]
  def change
    create_table :user_event_application_reads do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event_application, null: false, foreign_key: true
      t.datetime :last_read_at

      t.timestamps
    end
  end
end
