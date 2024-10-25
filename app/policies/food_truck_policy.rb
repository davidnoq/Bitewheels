class FoodTruckPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.foodtruckowner?
        # Food truck owners can see their own food trucks
        scope.where(user: user)
      elsif user.eventorganizer?
        # Event organizers can see all food trucks associated with their events
        scope.joins(event_applications: :event).where(events: { user_id: user.id })
      else
        # Other users cannot see any food trucks
        scope.none
      end
    end
  end

  def index?
    user.foodtruckowner? || user.eventorganizer?
  end

  def show?
    user.eventorganizer? || (user.foodtruckowner? && record.user == user)
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
