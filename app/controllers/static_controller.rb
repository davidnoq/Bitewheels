class StaticController < ApplicationController
	# This allows access to the home page without authentication
	skip_before_action :authenticate_user!, only: :home
  
	def home
	  # Render the home page
	end
  end
  