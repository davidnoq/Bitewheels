# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  protected

  # Permit additional parameters during sign up
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:phone_number, :first_name, :last_name, :country])
  end

  # Permit additional parameters during account updates
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:phone_number, :first_name, :last_name, :country])
  end
end
