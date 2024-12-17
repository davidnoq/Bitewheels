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
        # Retrieve event_application_id from params
        event_application_id = params[:food_truck_rating][:event_application_id]
        @event_application = EventApplication.find(event_application_id)
        
        redirect_to event_event_application_path(@event_application.event, @event_application), notice: "Rating and review submitted successfully."
      else
        # If failure, also redirect to event_application page
        event_application_id = params[:food_truck_rating][:event_application_id]
        @event_application = EventApplication.find(event_application_id)
    
        redirect_to event_event_application_path(@event_application.event, @event_application), alert: "Failed to submit rating and review."
      end
    end
    
  
    # GET /food_trucks/:food_truck_id/food_truck_ratings/:id/edit
    def edit
      
      
    end
  
    # PATCH/PUT /food_trucks/:food_truck_id/food_truck_ratings/:id
    def update
      if @food_truck_rating.update(food_truck_rating_params)
        # Retrieve event_application_id from params
        event_application_id = params[:food_truck_rating][:event_application_id]
        @event_application = EventApplication.find(event_application_id)
    
        redirect_to event_event_application_path(@event_application.event, @event_application), notice: "Rating and review updated successfully."
      else
        # If update fails, re-render edit
        render :edit, status: :unprocessable_entity
      end
    end
    # DELETE /food_trucks/:food_truck_id/food_truck_ratings/:id
    def destroy
      # Store the event_application_id from params before destroying the rating
      event_application_id = params[:event_application_id]
      @food_truck_rating.destroy
      @event_application = EventApplication.find(event_application_id)
      
      redirect_to event_event_application_path(@event_application.event, @event_application), notice: "Rating and review deleted successfully."
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