class FoodTruckRatingPolicy < ApplicationPolicy
    def edit?
      user == record.user
    end
  
    def update?
      edit?
    end
  
    def destroy?
      edit?
    end
  
    class Scope < Scope
      def resolve
        scope.all
      end
    end
  end