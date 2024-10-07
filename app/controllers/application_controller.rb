# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  include Pundit

  before_action :configure_permitted_parameters, if: :devise_controller?

  # Redirect to home page after sign out
  def after_sign_out_path_for(resource_or_scope)
    root_path # This will redirect to the root path, which is `pages#home`
  end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  # Handle unauthorized access gracefully
  def user_not_authorized
    flash[:alert] = "You are not authorized to view this page."
    redirect_to(root_path)
  end

  # Add extra permitted parameters for Devise
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone_number])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone_number])
  end
end
