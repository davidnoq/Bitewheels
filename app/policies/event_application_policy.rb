class EventApplicationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.eventorganizer?
        # Event organizers can see all applications for their events
        scope.joins(:event).where(events: { user_id: user.id })
      elsif user.foodtruckowner?
        # Food truck owners can see all their applications
        scope.joins(:food_truck).where(food_trucks: { user_id: user.id })
      else
        # Other users cannot see any applications
        scope.none
      end
    end
  end

  
  def show?
    (user.eventorganizer? && record.event.user_id == user.id) ||
    (user.foodtruckowner? && record.food_truck.user_id == user.id)
  end

  def create?
    user.foodtruckowner?
  end

  def update?
    (user.eventorganizer? && record.event.user_id == user.id) ||
    (user.foodtruckowner? && record.food_truck.user_id == user.id)
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
  def show_application_food_truck?
    # Define the authorization logic here
    # For example, allow if the user is the event organizer or the food truck owner
    user.eventorganizer? || user.foodtruckowner?
  end
  
  def applications?
    user.eventorganizer? || user.foodtruckowner?
  end
end
