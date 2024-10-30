class EventApplicationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event
  before_action :set_event_application, only: [ :approve, :reject, :show ]

  def index
    @event_applications = @event.event_applications.page(params[:page]).per(10)
  end

  def show
    @event_application
    @food_truck = @event_application.food_truck
  end

  def create
    food_truck_ids = params[:food_truck_ids].reject(&:blank?)
    success = false

    food_truck_ids.each do |food_truck_id|
      @event_application = EventApplication.new(
        event: @event,
        food_truck_id: food_truck_id,
        status: :pending
      )
      authorize @event_application
      success = true if @event_application.save
    end

    if success
      flash[:notice] = "Application submitted successfully."
    else
      flash[:alert] = "Failed to submit application."
    end

    redirect_to @event
  end

  def approve
    authorize @event_application
    if @event_application.status == 'approved'
      redirect_to event_event_application_path(@event, @event_application), alert: "Application has already been approved."
      return
    end
    # Check if the event has food truck slots available
    if @event.foodtruck_amount > 0
      Event.transaction do
        
        @event.update!(foodtruck_amount: @event.foodtruck_amount - 1)
  
        @event_application.update!(status: :approved)
      end
      redirect_to event_event_application_path(@event, @event_application), notice: "Application approved successfully."
    else
      redirect_to event_event_application_path(@event, @event_application), alert: "No available slots for food trucks."
    end
  end

  def reject
    authorize @event_application
    if @event_application.status == 'rejected'
      redirect_to event_event_application_path(@event, @event_application), alert: "Application has already been rejected."
      return
    end
    if @event_application.status == 'approved'
      Event.transaction do
        @event.update!(foodtruck_amount: @event.foodtruck_amount + 1)
  
        @event_application.update!(status: :rejected)
      end
      redirect_to event_event_application_path(@event, @event_application), notice: "Application rejected and slot freed up successfully."
    else
      @event_application.update!(status: :rejected)
      redirect_to event_event_application_path(@event, @event_application), notice: "Application rejected successfully."
    end
  end
  

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_event_application
    @event_application = EventApplication.find(params[:id])
  end
end
