# app/policies/event_policy.rb
class EventPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end

  def index?
    user&.eventorganizer?
  end

  def show?
    user&.eventorganizer?
  end

  def create?
    user&.eventorganizer?
  end

  def new?
    create?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end
end
