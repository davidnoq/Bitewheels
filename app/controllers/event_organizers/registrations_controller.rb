class EventOrganizers::RegistrationsController < Devise::RegistrationsController
    protected
  
    def after_sign_in_path_for(resource)
      # Redirect to the event creation page after signing up
      new_event_path # or whatever the path to your event creation page is
    end
  end
  