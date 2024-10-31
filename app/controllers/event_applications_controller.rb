# app/controllers/event_applications_controller.rb
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
    unless @event.accepting_applications
      flash[:alert] = "This event is no longer accepting applications."
      redirect_to @event and return
    end

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
    @event_application = @event.event_applications.find(params[:id])
  end
end
