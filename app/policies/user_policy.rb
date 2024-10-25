# app/policies/user_policy.rb
class UserPolicy < ApplicationPolicy
  def show?
    user == record  # Only allow viewing own profile
  end

  def edit?
    user == record  # Only allow editing own profile
  end

  def update?
    edit?
  end
end
