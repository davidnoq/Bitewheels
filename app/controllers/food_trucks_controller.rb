# app/controllers/food_trucks_controller.rb

class FoodTrucksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_food_truck, only: [:show, :edit, :update, :destroy, :remove_permit]
  after_action :verify_authorized, except: [:index, :dashboard]
  after_action :verify_policy_scoped, only: [:index, :dashboard]

  # GET /food_trucks
  def index
    authorize FoodTruck
    @food_trucks = policy_scope(FoodTruck)
                      .where(user: current_user)
                      .page(params[:food_trucks_page]) 
                      .per(5)                              

    # Use policy_scope for event applications related to the user's food trucks
    @event_applications = policy_scope(EventApplication)
                          .joins(:food_truck)
                          .where(food_trucks: { user_id: current_user.id })
                          .includes(:event, :food_truck)
                          .page(params[:applications_page]).per(10)
                          authorize @food_trucks
   
  end

  # GET /food_trucks/1
  def show
    @food_truck = FoodTruck.find(params[:id])

    authorize @food_truck
  end

  # GET /food_trucks/new
  def new
    if current_user.eventorganizer?
      redirect_to root_path, alert: "Event organizers cannot create food trucks."
      return
    end

    @food_truck = current_user.food_trucks.build
    authorize @food_truck
  end

  # GET /food_trucks/1/edit
  def edit
    authorize @food_truck
  end

  # POST /food_trucks
  def create
    @food_truck = current_user.food_trucks.build(food_truck_params)
    authorize @food_truck

    if @food_truck.save
      redirect_to @food_truck, notice: "Food Truck was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /food_trucks/1
  def update
    authorize @food_truck

    if @food_truck.update(food_truck_params)
      redirect_to @food_truck, notice: "Food Truck was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /food_trucks/1
  def destroy
    authorize @food_truck
    @food_truck.destroy!

    redirect_to food_trucks_path, status: :see_other, notice: "Food Truck was successfully destroyed."
  end

  
  
  private

  # Use callbacks to share common setup or constraints between actions.
  def set_food_truck
    if current_user.eventorganizer?
      @food_truck = FoodTruck.find(params[:id]) # Allow event organizers to access any food truck
    else
      @food_truck = current_user.food_trucks.find(params[:id]) # Regular users can only access their own food trucks
    end
  end

  

  # Only allow a list of trusted parameters through.
  def food_truck_params
    params.require(:food_truck).permit(:name, :permit, :cuisine, :number_of_food_trucks, menu_images: [], food_images: [])
  end
end
