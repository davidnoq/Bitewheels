# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :authenticate_user! # Ensure the user is logged in before accessing the profile

  def show
    @user = current_user # Set the @user variable to the currently logged-in user
  end
end
