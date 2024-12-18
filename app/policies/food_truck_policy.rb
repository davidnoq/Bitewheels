class FoodTruckPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.foodtruckowner?
        # Food truck owners can see their own food trucks
        scope.where(user: user)
      else
        # Other users cannot see any food trucks
        scope.none
      end
    end
  end

  def index?
    user.foodtruckowner? 
  end

  def show?
   (user.foodtruckowner? && record.user == user)
  end

  def create?
    user.foodtruckowner?
  end

  def remove_menu_file?
    user.foodtruckowner?
  end
  def remove_permit?
    user == record.user || user.eventorganizer?
  end
  def remove_food_image?
    user == record.user || user.eventorganizer?
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
