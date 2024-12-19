class EventPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user&.eventorganizer?
        # Event organizers can see all their events (both drafts and published)
        scope.where(user: user)
      else
        # Regular users and visitors can only see published events
        scope.published
      end
    end
  end

  def index?
    user&.eventorganizer?
  end
  def search?
    true
  end
  def all?
    true
  end

  def show?
    if user.present?
      # Allow event organizers to see their events, and regular users to see only published ones
      record.published? || (user.eventorganizer? && record.user_id == user.id)
    else
      # Visitors can only see published events
      record.published?
    end
  end
  def address?
    return false unless user&.foodtruckowner? # Only food truck owners are concerned

    # Check if any of the user's food trucks have applied to this event
    user.food_trucks.joins(:event_applications).where(event_applications: { event_id: record.id }).exists?
  end
  def complete?
    user&.eventorganizer?
  end
  def completed?
    user&.eventorganizer?
  end

  def create?
    user&.eventorganizer?
  end

  def new?
    create?
  end

  def edit?
    user&.eventorganizer? && record.user_id == user.id 
  end

  def update?
    edit?
  end

  def destroy?
    user&.eventorganizer? && record.user_id == user.id
  end

  def publish?
    user&.eventorganizer? && record.user_id == user.id && record.draft?
  end

  

end
