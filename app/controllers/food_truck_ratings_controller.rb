# app/controllers/food_truck_ratings_controller.rb
class FoodTruckRatingsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_food_truck
    before_action :set_food_truck_rating, only: [:edit, :update, :destroy]
    after_action :verify_authorized, only: [:edit, :update, :destroy]
  
    # POST /food_trucks/:food_truck_id/food_truck_ratings
    def create
      @food_truck_rating = @food_truck.food_truck_ratings.build(food_truck_rating_params)
      @food_truck_rating.user = current_user
  
      if @food_truck_rating.save
        redirect_to food_truck_path(@food_truck), notice: "Rating and review submitted successfully."
      else
        redirect_to food_truck_path(@food_truck), alert: "Failed to submit rating and review."
      end
    end
  
    # GET /food_trucks/:food_truck_id/food_truck_ratings/:id/edit
    def edit
      # Authorization (if using Pundit or similar)
    end
  
    # PATCH/PUT /food_trucks/:food_truck_id/food_truck_ratings/:id
    def update
      if @food_truck_rating.update(food_truck_rating_params)
        redirect_to food_truck_path(@food_truck), notice: "Rating and review updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end
  
    # DELETE /food_trucks/:food_truck_id/food_truck_ratings/:id
    def destroy
      @food_truck_rating.destroy
      redirect_to food_truck_path(@food_truck), notice: "Rating and review deleted successfully."
    end
  
    private
  
    def set_food_truck
      @food_truck = FoodTruck.find(params[:food_truck_id])
    end
  
    def set_food_truck_rating
      @food_truck_rating = @food_truck.food_truck_ratings.find(params[:id])
      authorize @food_truck_rating
    end
  
    def food_truck_rating_params
      params.require(:food_truck_rating).permit(:rating, :review)
    end
  end