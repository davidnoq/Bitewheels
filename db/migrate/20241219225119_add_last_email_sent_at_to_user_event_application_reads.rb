class AddLastEmailSentAtToUserEventApplicationReads < ActiveRecord::Migration[7.2]
  def change
    add_column :user_event_application_reads, :last_email_sent_at, :datetime
  end
end
