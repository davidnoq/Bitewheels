class EventApplicationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event
  before_action :set_event_application, only: [ :approve, :reject, :show ]

  def index
    @event_applications = @event.event_applications.page(params[:page]).per(10)
  end

  def show
    @event_application
    # authorize @event_application
    # @food_truck = @event_application.food_truck
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
    if @event_application.update(status: :approved)
      redirect_to request.referer || event_show_application_food_truck_path(@event_application.event, @event_application, @event_application.food_truck), notice: "Application approved successfully."
    else
      redirect_to request.referer || event_show_application_food_truck_path(@event_application.event, @event_application, @event_application.food_truck), alert: "Failed to approve application."
    end
  end

  def reject
    authorize @event_application
    if @event_application.update(status: :rejected)
      redirect_to request.referer || event_show_application_food_truck_path(@event_application.event, @event_application, @event_application.food_truck), notice: "Application rejected successfully."
    else
      redirect_to request.referer || event_show_application_food_truck_path(@event_application.event, @event_application, @event_application.food_truck), alert: "Failed to reject application."
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
