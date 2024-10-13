# app/policies/food_truck_policy.rb

class FoodTruckPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.foodtruckowner?
        # Food truck owners can see their own applications
        scope.where(user: user)
      elsif user.eventorganizer?
        # Event organizers can see all applications for their events
        scope.joins(:event).where(events: { user_id: user.id })
      else
        # Other users cannot see any applications
        scope.none
      end
    end
  end

  def index?
    user.foodtruckowner? || user.eventorganizer?
  end

  def show?
    user.foodtruckowner? && record.user == user ||
    user.eventorganizer? && record.event.user == user
  end

  def create?
    user.foodtruckowner?
  end

  def new?
    create?
  end

  def update?
    user.foodtruckowner? && record.user == user
  end

  def edit?
    update?
  end

  def destroy?
    user.foodtruckowner? && record.user == user
  end
end
