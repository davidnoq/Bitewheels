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
    (user.eventorganizer? && record.event.user_id == user.id)
    
  end

  def create?
    user.foodtruckowner?
  end

  def update?
    (user.eventorganizer? && record.event.user_id == user.id)
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
