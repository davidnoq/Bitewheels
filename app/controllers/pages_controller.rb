# app/controllers/pages_controller.rb
class PagesController < ApplicationController
 
  def home
  end

  def promote_to_event_organizer
    if current_user.user?
      current_user.update(role: :eventorganizer)
      flash[:notice] = "You are now an event organizer!"
      redirect_to events_path
    else
      flash[:alert] = "You are already an event organizer or food truck owner."
      redirect_to root_path
    end
  end
  def promote_to_food_truck_owner
    if current_user.user?
      current_user.update(role: :foodtruckowner)
      flash[:notice] = "You are now a food truck owner!"
      redirect_to food_trucks_path
    else
      flash[:alert] = "You are already an event organizer or food truck owner."
      redirect_to root_path
    end
  end
end
