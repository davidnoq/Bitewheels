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
    user&.eventorganizer? || user&.foodtruckowner? 
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

  def applications?
    user&.eventorganizer?
  end

end
