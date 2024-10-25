class EventsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_event, only: %i[show edit update destroy publish]
  after_action :verify_authorized, except: [ :index, :published, :search ]
  after_action :verify_policy_scoped, only: :index

  # renders current users scope of events, as well as the current users pending applications they must view
  def index
    @events = policy_scope(Event)
               .includes(:food_trucks)
               .page(params[:page])
               .per(10)

    authorize @events

    if current_user&.eventorganizer?
      @pending_applications_count = EventApplication.joins(:event)
                                                    .where(events: { user_id: current_user.id }, status: "pending")
                                                    .count
    end
  end

  # right now this renders ALL published, since search functionality not implemented
  def events_near_me
    authorize :event, :events_near_me?
    @events = Event.published
                   .includes(:food_trucks)
                   .page(params[:page])
                   .per(10)
  end

  # GET /events/applications
  def applications
    authorize :event, :applications?
    @event_applications = policy_scope(EventApplication)
                           .joins(:event)
                           .where(events: { user_id: current_user.id })
                           .includes(:food_truck, :event)
                           .order(created_at: :desc)
                           .page(params[:page])
                           .per(10)
  end

  # food truck applictions partial
  def show_application_food_truck
    @event_application = EventApplication.find(params[:id])
    @food_truck = @event_application.food_truck
    @event_applications = @food_truck.event_applications.where(event: @event_application.event)

    authorize @event_application
  end

  def show
    authorize @event
    @food_trucks = @event.food_trucks

    if current_user&.foodtruckowner?
      applied_food_truck_ids = current_user.food_trucks.joins(:event_applications)
                                             .where(event_applications: { event_id: @event.id })
                                             .pluck(:id)
      @available_food_trucks = current_user.food_trucks.where.not(id: applied_food_truck_ids)
    end
  end


  def new
    @event = current_user.events.build
    authorize @event
  end

  def edit
    authorize @event
  end

  def create
    @event = current_user.events.build(event_params)
    authorize @event

    if @event.save
      redirect_to @event, notice: "Event was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @event
    if @event.update(event_params)
      redirect_to @event, notice: "Event was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @event
    @event.destroy!

    redirect_to events_path, status: :see_other, notice: "Event was successfully destroyed."
  end

  # PATCH /events/1/publish
  def publish
    authorize @event, :publish?
    if @event.update(status: :published)
      redirect_to @event, notice: "Event was successfully published."
    else
      redirect_to @event, alert: "Failed to publish the event."
    end
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    permitted = [ :name, :address, :start_date, :end_date, :expected_attendees, :foodtruck_amount, :latitude, :longitude ]
    permitted << :status if user_signed_in? && current_user.eventorganizer?
    params.require(:event).permit(permitted)
  end
end
