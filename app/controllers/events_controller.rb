# app/controllers/events_controller.rb

class EventsController < ApplicationController
  before_action :authenticate_user! # Ensure user is logged in
  before_action :set_event, only: %i[show edit update destroy publish]
  after_action :verify_authorized, except: [:index]
  after_action :verify_policy_scoped, only: :index

  # GET /events
  def index
    if current_user.eventorganizer?
      # Fetch published and draft events belonging to the current event organizer
      @published_events = policy_scope(Event).where(status: 'published', user: current_user).includes(:food_trucks)
      @draft_events = policy_scope(Event).where(status: 'draft', user: current_user).includes(:food_trucks)
    else
      # For regular users, fetch only published events
      @published_events = policy_scope(Event).published.includes(:food_trucks)
      @draft_events = Event.none # No draft events for regular users
    end
  end

  # GET /events/1 or /events/1.json
  def show
    authorize @event
  end

  # GET /events/new
  def new
    @event = current_user.events.build
    authorize @event
  end

  # GET /events/1/edit
  def edit
    authorize @event
  end

  # POST /events or /events.json
  def create
    @event = current_user.events.build(event_params)
    authorize @event # Explicitly authorize creation

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: "Event was successfully created." }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    authorize @event # Explicitly authorize update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: "Event was successfully updated." }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    authorize @event # Explicitly authorize deletion
    @event.destroy!

    respond_to do |format|
      format.html { redirect_to events_path, status: :see_other, notice: "Event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # PATCH /events/1/publish
  def publish
    authorize @event, :publish?
    if @event.publish!
      redirect_to @event, notice: 'Event was successfully published.'
    else
      redirect_to @event, alert: 'Failed to publish the event.'
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    # Only permit :status if the current user is an event organizer
    permitted = [:name, :description, :address, :start_date, :end_date, :expected_attendees, :logo, :foodtruck_amount, :latitude, :longitude]
    permitted << :status if current_user.eventorganizer?
    params.require(:event).permit(permitted)
  end
end
