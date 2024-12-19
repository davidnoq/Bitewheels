# app/controllers/users/registrations_controller.rb

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  # Action to apply to an event
  def apply_to_event
    # Save the event ID in session for redirection after signup/login
    session[:event_id] = params[:event_id]
    redirect_to new_user_registration_path
  end

  # Override the `build_resource` method to set the role before saving
  def build_resource(hash = {})
  super
  role = params[:role] || params.dig(:user, :role)

  if session[:event_id]
    resource.role = 'foodtruckowner'
  elsif role == 'eventorganizer'
    resource.role = 'eventorganizer'
  end
end

  # Override the `create` method without additional redirection
  def create
    super
    # No need to update the role here since it's set in `build_resource`
  end

  # Override the path after sign up
  def after_sign_up_path_for(resource)
    if session[:event_id]
      new_food_truck_path
    elsif resource.eventorganizer?
      events_path
    else
      super
    end
  end


  protected

  # Permit additional parameters for sign up
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:phone_number, :first_name, :last_name, :country, :role])
  end

  # Permit additional parameters for account update
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:phone_number, :first_name, :last_name, :country])
  end
end
