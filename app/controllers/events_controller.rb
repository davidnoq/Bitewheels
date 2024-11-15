# app/controllers/events_controller.rb
class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :search, :all]
  before_action :set_event, only: %i[show edit update destroy publish complete]
  after_action :verify_authorized, except: [:index, :show, :search]
  after_action :verify_policy_scoped, only: :index

  def index

    @events = policy_scope(Event)
    .includes(:food_trucks)
    .page(params[:page])
    .per(12)
   authorize @events
    @published_events = @events.select { |event| event.status == 'published' }
    @drafted_events = @events.select { |event| event.status == 'draft' }
  
    if current_user&.eventorganizer?
      # Fetch pending applications for the current user's events
      @pending_applications_per_event = EventApplication
        .where(event_id: @events.pluck(:id), status: 'pending')
        .group(:event_id)
        .count
      @events_with_pending_applications = @pending_applications_per_event.keys
    end
  end

  
  def search
    @events = policy_scope(Event)
  
    # Location-based filtering
    if params[:latitude].present? && params[:longitude].present?
      coordinates = [params[:latitude].to_f, params[:longitude].to_f]
      radius = params[:radius].present? ? params[:radius].to_i : 50
      nearby_event_ids = @events.near(coordinates, radius, units: :mi, order: false).pluck(:id)
      @events = @events.where(id: nearby_event_ids)
      @search_title = "Events near your location"
    elsif params[:address].present?
      coordinates = Geocoder.coordinates(params[:address])
      radius = params[:radius].present? ? params[:radius].to_i : 50
  
      if coordinates
        nearby_event_ids = @events.near(coordinates, radius, units: :mi, order: false).pluck(:id)
        @events = @events.where(id: nearby_event_ids)
        @search_title = "Events near #{params[:address].titleize}"
      else
        redirect_to events_path, alert: "Could not geocode the provided address." and return
      end
    end
  
    # Date-based filtering
    if params[:start_date].present? && params[:end_date].present?
      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])
      @events = @events.where("start_date >= ? AND end_date <= ?", start_date, end_date)
    end
  
    # Final pagination and authorization
    @events = @events.page(params[:page]).per(12)
    authorize @events
  
    @published_events = @events.where(status: 'published')
    @drafted_events = @events.where(status: 'draft')
  
    render :index
  end

  def complete
    authorize @event, :complete?
    if @event.update(status: :completed)
      redirect_to @event, notice: "Event marked as completed."
    else
      redirect_to @event, alert: "Failed to mark the event as completed."
    end
  end

  # Display all completed events
  def completed
    @events = policy_scope(Event).where(status: :completed).page(params[:page]).per(12)
    authorize @events
  end

  def all
    @events = Event.where(status: 'published')
    authorize :event, :all? 
    # Location-based filtering
    if params[:latitude].present? && params[:longitude].present?
      coordinates = [params[:latitude].to_f, params[:longitude].to_f]
      radius = params[:radius].present? ? params[:radius].to_i : 50
      nearby_event_ids = @events.near(coordinates, radius, units: :mi, order: false).pluck(:id)
      @events = @events.where(id: nearby_event_ids)
      @search_title = "Events near your location"
    elsif params[:address].present?
      coordinates = Geocoder.coordinates(params[:address])
      radius = params[:radius].present? ? params[:radius].to_i : 50
  
      if coordinates
        nearby_event_ids = @events.near(coordinates, radius, units: :mi, order: false).pluck(:id)
        @events = @events.where(id: nearby_event_ids)
        @search_title = "Events near #{params[:address].titleize}"
      else
        redirect_to all_published_events_path, alert: "Could not geocode the provided address." and return
      end
    end
  
    # Date-based filtering
    if params[:start_date].present? && params[:end_date].present?
      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])
      @events = @events.where("start_date >= ? AND end_date <= ?", start_date, end_date)
    end
  
    # Final pagination
    @events = @events.page(params[:page]).per(12)
    authorize @events
  end
  
  def show
    authorize @event

    @approved_count = @event.approved_applications_count
    @food_trucks = @event.food_trucks
    @approved_food_trucks = @event.food_trucks.joins(:event_applications)
                                            .where(event_applications: { status: 'approved' })
                                            .distinct
  
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
      @event.update_accepting_applications!
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
    permitted = [:name, :address, :start_date, :end_date, :expected_attendees, :foodtruck_amount, :latitude, :longitude, :credit_cost]
    permitted << :status if user_signed_in? && current_user.eventorganizer?
    params.require(:event).permit(permitted)
  end

 
end
