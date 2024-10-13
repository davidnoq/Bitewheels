# app/controllers/food_trucks_controller.rb

class FoodTrucksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:new, :create]
  before_action :set_food_truck, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized, except: [:index]
  after_action :verify_policy_scoped, only: :index

  # GET /food_trucks or /food_trucks.json
  def index
    @food_trucks = policy_scope(FoodTruck).where(user: current_user).includes(:event)
    @published_events = Event.where(status: 'published').where.not(id: @food_trucks.pluck(:event_id))
  end

  # GET /food_trucks/1 or /food_trucks/1.json
  def show
    authorize @food_truck
  end

  # GET /events/:event_id/food_trucks/new
  def new
    if current_user.eventorganizer?
      redirect_to @event, alert: "Event organizers cannot apply to events."
      return
    end

    @food_truck = current_user.food_trucks.build(event: @event)
    authorize @food_truck
  end

  # GET /food_trucks/1/edit
  def edit
    authorize @food_truck
  end

  # POST /events/:event_id/food_trucks or /events/:event_id/food_trucks.json
  def create
    @food_truck = current_user.food_trucks.build(food_truck_params)
    @food_truck.event = @event
    authorize @food_truck

    respond_to do |format|
      if @food_truck.save
        format.html { redirect_to @food_truck, notice: "Food Truck was successfully created." }
        format.json { render :show, status: :created, location: @food_truck }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @food_truck.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /food_trucks/1 or /food_trucks/1.json
  def update
    authorize @food_truck
    respond_to do |format|
      if @food_truck.update(food_truck_params)
        format.html { redirect_to @food_truck, notice: "Food Truck was successfully updated." }
        format.json { render :show, status: :ok, location: @food_truck }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @food_truck.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /food_trucks/1 or /food_trucks/1.json
  def destroy
    authorize @food_truck
    @food_truck.destroy!

    respond_to do |format|
      format.html { redirect_to food_trucks_path, status: :see_other, notice: "Food Truck was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_food_truck
    @food_truck = FoodTruck.find(params[:id])
  end

  def set_event
    @event = Event.find(params[:event_id])
  end

  # Only allow a list of trusted parameters through.
  def food_truck_params
    params.require(:food_truck).permit(:cuisine)
  end
end
