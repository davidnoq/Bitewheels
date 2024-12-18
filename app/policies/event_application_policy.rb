# app/policies/event_application_policy.rb
class EventApplicationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.eventorganizer?
        # Applications for events the user organizes
        scope.joins(:event).where(events: { user_id: user.id })
      elsif user.foodtruckowner?
        # Applications for the user's food trucks
        scope.joins(:food_truck).where(food_trucks: { user_id: user.id })
      else
        # No access for other users
        scope.none
      end
    end
  end

  def index?
    user.eventorganizer? || user.foodtruckowner?
  end

  def show?
    # Allow viewing if the user owns the associated event or food truck
    record.event.user_id == user.id || record.food_truck.user_id == user.id
  end

  def create?
    user.foodtruckowner?
  end

  def new?
    user.foodtruckowner?
  end

  def update?
    user.eventorganizer? && record.event.user_id == user.id
  end

  def destroy?
    user.foodtruckowner? && record.food_truck.user_id == user.id
  end

  def approve?
    user.eventorganizer? && record.event.user_id == user.id
  end
  
  def reject?
    approve?
  end
end
