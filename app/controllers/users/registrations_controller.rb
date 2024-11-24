class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  def apply_to_event
    # Save the event ID in session for redirection after signup/login
    session[:event_id] = params[:event_id]
    redirect_to new_user_registration_path
  end

  def create
    super do |user|
      if session[:event_id]
        # Automatically make the user a food truck owner if applying from an event link
        user.update(role: 'foodtruckowner')
        # Redirect to food truck creation after signup
        redirect_to new_food_truck_path and return
      elsif params[:user][:role] == 'eventorganizer'
        user.update(role: 'eventorganizer')
      end
    end
  end

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

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:phone_number, :first_name, :last_name, :country])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:phone_number, :first_name, :last_name, :country])
  end
end
