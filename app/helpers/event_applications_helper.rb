# app/helpers/event_applications_helper.rb
module EventApplicationsHelper
    def new_messages_count(application)
      read_status = UserEventApplicationRead.find_by(user: current_user, event_application: application)
      last_read = read_status&.last_read_at || Time.at(0)
      
      # Exclude messages sent by the current_user
      count = application.messages.where("created_at > ? AND user_id != ?", last_read, current_user.id).count
      
      count > 9 ? 9 : count
    end
  end
  