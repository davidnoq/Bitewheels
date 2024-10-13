# app/policies/event_policy.rb
class EventPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.eventorganizer?
        # Event organizers can see their own drafts and all published events
        scope.where(user: user).or(scope.where(status: 'published'))
      else
        # Regular users see only published events
        scope.where(status: 'published')
      end
    end
  end

  def index?
    true
  end

  def show?
    record.published? || (user.eventorganizer? && record.user_id == user.id)
  end

  def create?
    user.eventorganizer?
  end

  def new?
    create?
  end

  def edit?
    user.eventorganizer? && record.user_id == user.id && record.draft?
  end

  def update?
    edit?
  end

  def destroy?
    user.eventorganizer? && record.user_id == user.id
  end

  def publish?
    user.eventorganizer? && record.user_id == user.id && record.draft?
  end
end
