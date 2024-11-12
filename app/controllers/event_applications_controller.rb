# app/controllers/event_applications_controller.rb
class EventApplicationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event_application, only: [:approve, :reject, :show]



  def index
    @event_applications = policy_scope(EventApplication).page(params[:page]).per(10)
    authorize @event_applications

    if current_user.eventorganizer?
      render "event_applications/index" # Renders the view for event organizers
    elsif current_user.foodtruckowner?
      render "event_applications/food_truck_index" # Renders the view for food truck owners
    else
      redirect_to root_path, alert: "You are not authorized to view applications."
    end
  end

  def show
    authorize @event_application
    @food_truck = @event_application.food_truck
    @event = @event_application.event
  
    # Dynamically render based on user role
    if current_user.foodtruckowner?
      render "event_applications/food_truck_show"
    else
      render "event_applications/show"
    end
  end

  

  def new
    # Initialize a new EventApplication object
    @event_application = @event.event_applications.new
    authorize @event_application
  
    # Fetch all food trucks owned by the current user that haven't applied to this event
    applied_truck_ids = @event.event_applications.pluck(:food_truck_id)
    @food_trucks = current_user.food_trucks.where.not(id: applied_truck_ids)
  
    # If the user has no eligible food trucks, redirect with an alert
    if @food_trucks.empty?
      flash[:alert] = "You don't have any eligible food trucks to apply with."
      redirect_to @event and return
    end
  end
  

  def create
    unless @event.accepting_applications
      flash[:alert] = "This event is no longer accepting applications."
      redirect_to @event and return
    end
  
    food_truck_ids = Array(params[:food_truck_ids] || params[:food_truck_id]).reject(&:blank?)
    food_trucks = current_user.food_trucks.where(id: food_truck_ids)
  
    if food_trucks.blank?
      flash[:alert] = "No valid food trucks selected."
      redirect_to :new and return
    end
  
    total_cost = food_trucks.size * @event.credit_cost
  
    applications = food_trucks.map do |food_truck|
      @event.event_applications.new(
        food_truck: food_truck,
        status: :pending
      )
    end
  
    if applications.all?(&:save)
      flash[:notice] = "Application(s) submitted successfully."
      redirect_to @event
    else
      flash[:alert] = "Failed to submit application(s). Ensure you haven't already applied."
      redirect_to :new
    end
  end

  # In the approve action
  def approve
    authorize @event_application

    if @event_application.approved?
      redirect_to event_event_application_path(@event, @event_application), alert: "Application has already been approved."
      return
    end

    ActiveRecord::Base.transaction do
      if @event_application.update(status: :approved)
        flash[:notice] = "Application approved successfully."
      else
        flash[:alert] = "Application could not be approved."
        raise ActiveRecord::Rollback
      end
    end

    redirect_to event_event_application_path(@event, @event_application)
  end

  def reject
    authorize @event_application

    if @event_application.rejected?
      redirect_to event_event_application_path(@event, @event_application), alert: "Application has already been rejected."
      return
    end

    ActiveRecord::Base.transaction do
      if @event_application.update(status: :rejected)
        flash[:notice] = "Application rejected successfully."
      else
        flash[:alert] = "Application could not be rejected."
        raise ActiveRecord::Rollback
      end
    end

    redirect_to event_event_application_path(@event, @event_application)
  end

  
  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_event_application
    @event_application = policy_scope(EventApplication).find(params[:id])
  end
  
end
