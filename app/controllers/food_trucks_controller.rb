# app/controllers/food_trucks_controller.rb

class FoodTrucksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_food_truck, only: [:show, :edit, :update, :destroy, :remove_menu_file, :remove_permit]
  after_action :verify_authorized, except: [:index]
  after_action :verify_policy_scoped, only: [:index]

  # GET /food_trucks
  def index
    # controller index
  @food_trucks = FoodTruck.where(user: current_user)
  policy_scope(@food_trucks)
  authorize @food_trucks
  @food_trucks = @food_trucks.page(params[:food_trucks_page]).per(5)
   
  end

  # GET /food_trucks/1
  def show
    if params[:event_application_id]
      # If nested under EventApplication, fetch via the associated EventApplication
      @event_application = policy_scope(EventApplication).find(params[:event_application_id])
      @food_truck = @event_application.food_truck
    else
      # If not nested, fetch directly by the FoodTruck ID
      @food_truck = policy_scope(FoodTruck).find(params[:id])
    end

    # Authorize the FoodTruck
    authorize @food_truck

  end

  # GET /food_trucks/new
  def new
    @food_truck = current_user.food_trucks.build
    authorize @food_truck
  end

  # GET /food_trucks/1/edit
  def edit
    @food_truck = current_user.food_trucks.find(params[:id])
    authorize @food_truck
  end
  

  # POST /food_trucks
  def create
    @food_truck = current_user.food_trucks.build(food_truck_params)
    authorize @food_truck
  
    if @food_truck.save
      if session[:event_id].present? # Check if the user started from an event link
        event_id = session.delete(:event_id) # Retrieve and delete the session variable
        redirect_to new_event_event_application_path(event_id: event_id, food_truck_id: @food_truck.id), notice: "Food Truck was successfully created. Proceed to apply to the event."
      else
        redirect_to @food_truck, notice: "Food Truck was successfully created."
      end
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  # app/controllers/food_trucks_controller.rb

def remove_permit
  authorize @food_truck
  if @food_truck.permit.attached?
    @food_truck.permit.purge
    redirect_to edit_food_truck_path(@food_truck), notice: "Permit was successfully removed."
  else
    redirect_to edit_food_truck_path(@food_truck), alert: "No permit found to remove."
  end
end

def remove_menu_file
  file = @food_truck.menu_files.attachments.find_by(id: params[:file_id])

  if file && file.record == @food_truck && file.name == "menu_files"
    authorize @food_truck
    file.purge
    redirect_to edit_food_truck_path(@food_truck), notice: "Menu file was successfully removed."
  else
    raise ActiveRecord::RecordNotFound, "Attachment not found for this Food Truck"
  end
end
  
def remove_food_image
  image = @food_truck.food_images.attachments.find_by(id: params[:image_id])

  if image && image.record == @food_truck && image.name == "food_images"
    authorize @food_truck
    image.purge
    redirect_to edit_food_truck_path(@food_truck), notice: "Food image was successfully removed."
  else
    raise ActiveRecord::RecordNotFound, "Attachment not found for this Food Truck"
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
    if params[:event_application_id]
      # Nested under EventApplication
      @event_application = policy_scope(EventApplication).find(params[:event_application_id])
      @food_truck = @event_application.food_truck
    elsif current_user.eventorganizer?
      # Direct access for event organizers
      @food_truck = FoodTruck.find(params[:id])
    else
      # Direct access for regular food truck owners
      @food_truck = current_user.food_trucks.find(params[:id])
    end
  end

  

  # Only allow a list of trusted parameters through.
  def food_truck_params
    params.require(:food_truck).permit(
      :name, 
      :permit, 
      :cuisine, 
      
      :number_of_food_trucks, 
      menu_files: [], 
      food_images: [], 
      food_image_descriptions: {}
    )
  end
end
