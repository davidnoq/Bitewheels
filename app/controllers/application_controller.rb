class ApplicationController < ActionController::Base
  # Include Devise's authentication helper methods
  before_action :authenticate_user!, except: [:home]

  private

  def authenticate_user!
    # Check if the user is signed in as an Event Organizer
    if event_organizer_signed_in?
      current_event_organizer
    # Check if the user is signed in as a Food Truck Owner
    elsif foodtruck_owner_signed_in?
      current_food_truck_owner
    else
      # If neither is signed in, redirect to the home page
      redirect_to root_path
    end
  end

  # Customize redirection after sign-in based on user type
  def after_sign_in_path_for(resource)
    if resource.is_a?(EventOrganizer)
      events_path # Redirect event organizers to events_path
    elsif resource.is_a?(FoodtruckOwner)
      food_truck_owners_path # Redirect food truck owners to their index page
    else
      root_path # Fallback if the resource is neither
    end
  end
end
