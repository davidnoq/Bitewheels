class EventApplicationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event
  before_action :set_event_application, only: [:approve, :reject, :show]

  def index
    @event_applications = @event.event_applications.page(params[:page]).per(10)
    authorize @event_applications
  end

  def show
    authorize @event_application
    @food_truck = @event_application.food_truck
  end

  def create
    food_truck_ids = params[:food_truck_ids].reject(&:blank?)
    total_cost = food_truck_ids.size * @event.credit_cost
    user = current_user.food_trucks.where(id: food_truck_ids).first&.user
  
    if user.nil?
      flash[:alert] = "Invalid food truck selection."
      redirect_to @event and return
    elsif user.credits < total_cost
      flash[:alert] = "You do not have enough credits to apply for all selected food trucks."
      redirect_to @event and return
    end
  
    success = false
  
    ActiveRecord::Base.transaction do
      food_truck_ids.each do |food_truck_id|
        @event_application = EventApplication.new(
          event: @event,
          food_truck_id: food_truck_id,
          status: :pending
        )
        authorize @event_application
        if @event_application.save
          success = true
        else
          raise ActiveRecord::Rollback
        end
      end
    end
  
    if success
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
    # Check if the event has food truck slots available
    if @event.foodtruck_amount > 0
      Event.transaction do
        @event.decrement!(:foodtruck_amount)
        @event_application.update!(status: :approved)
      end
      redirect_to event_event_application_path(@event, @event_application), notice: "Application approved successfully."
    else
      redirect_to event_event_application_path(@event, @event_application), alert: "No available slots for food trucks."
    end
  end

  def reject
    authorize @event_application
    if @event_application.rejected?
      redirect_to event_event_application_path(@event, @event_application), alert: "Application has already been rejected."
      return
    end

    Event.transaction do
      if @event_application.approved?
        @event.increment!(:foodtruck_amount)
      end
      @event_application.update!(status: :rejected)
    end

    redirect_to event_event_application_path(@event, @event_application), notice: "Application rejected successfully."
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_event_application
    @event_application = EventApplication.find(params[:id])
    @event_application = @event.event_applications.find(@event_application.id)
  end
end
