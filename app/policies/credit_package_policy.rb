# app/policies/credit_package_policy.rb

class CreditPackagePolicy < ApplicationPolicy
    def purchase?
      user.foodtruckowner? || user.user?
    end
  
    class Scope < Scope
      def resolve
        scope.all
      end
    end
  end
  