# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  include Pundit::Authorization

  # before you use the sign in controller, if using devise use the func below
  
  before_action :configure_permitted_parameters, if: :devise_controller?

  # redirect to home page after sign out
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  # any pundit error will give a not authorized error and go to
  # the user not authorized function below
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  
  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  #extra parameters for devise
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone_number])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone_number])
  end
end
