# app/controllers/event_applications_controller.rb
class EventApplicationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:index, :new, :create, :approve, :reject]
  before_action :set_event_application, only: [:show, :approve, :reject]


  def index
    if @event
      # Nested route: Event Organizer viewing applications for a specific event
      @event_applications = policy_scope(@event.event_applications).page(params[:page]).per(10)
    else
      # Top-level route: Food Truck Owner viewing their own applications
      @event_applications = policy_scope(EventApplication).page(params[:page]).per(10)
    end
    

    authorize @event_applications
    if params[:start_date].present? && params[:end_date].present?
      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])
      @event_applications = @event_applications.where(created_at: start_date.beginning_of_day..end_date.end_of_day)
    end
    UserEventApplicationRead.find_or_initialize_by(user: current_user, event_application: @event_application)
      .update(last_read_at: Time.current)

    if current_user.eventorganizer?
      render "event_applications/index" # View for Event Organizers
    else
      render "event_applications/food_truck_index" # View for Food Truck Owners
    end
  end

  def show
    authorize @event_application
    @food_truck = @event_application.food_truck
    @event = @event_application.event
    @messages = @event_application.messages.order(created_at: :asc)
   @message = @event_application.messages.new  # For form submission if needed
  
      # Update or create the read status
      UserEventApplicationRead.find_or_initialize_by(user: current_user, event_application: @event_application)
      .update(last_read_at: Time.current)

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
    else
      flash[:alert] = "Failed to submit application(s). Ensure you haven't already applied."
    end

    redirect_to @event
  end

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
    @event = Event.find(params[:event_id]) if params[:event_id].present?
  end
  

  def set_event_application
    if @event
      # Nested route: Event Organizer viewing applications for a specific event
      @event_application = @event.event_applications.find(params[:id])
      authorize @event_application
    else
      # Top-level route: Food Truck Owner viewing their own applications
      @event_application = policy_scope(EventApplication).find(params[:id])
      authorize @event_application
    end
    if params[:id] != @event_application.slug
      redirect_to @event_application, :status => :moved_permanently
    end
  end
  
end
