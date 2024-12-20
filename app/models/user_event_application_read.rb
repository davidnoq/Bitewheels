# app/models/user_event_application_read.rb
class UserEventApplicationRead < ApplicationRecord
  belongs_to :user
  belongs_to :event_application

  validates :user_id, uniqueness: { scope: :event_application_id }

  # Method to calculate unread messages since last email
  def unread_messages_since_last_email
    if last_email_sent_at
      event_application.messages.where("created_at > ? AND user_id != ?", last_email_sent_at, user.id).count
    else
      event_application.messages.where("user_id != ?", user.id).count
    end
  end
end
