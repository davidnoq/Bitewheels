class EventsController < ApplicationController
  before_action :authenticate_event_organizer!, only: [:new, :create]

  def new
    @event = Event.new
  end

  
  
  

  def create
    @event = Event.new(event_params)
    @event.organizer = current_event_organizer

    if @event.save
      redirect_to events_path, notice: 'Event was successfully created.'
    else
      render :new
    end
  end
  
  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to events_path, notice: 'Event was successfully deleted.'
  end

  private

  def event_params
    params.require(:event).permit(
      :name,
      :location,
      :date,
      :expected_attendees,
      :description,
      :logo,
      :amount_of_food_trucks,
      food_trucks_attributes: [:id, :name, :cuisine, :_destroy]
    )
  end
end
