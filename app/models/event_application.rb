class EventApplication < ApplicationRecord
  belongs_to :food_truck
  belongs_to :event

  # Enums
  enum status: { pending: 0, approved: 1, rejected: 2 }

  # Validations
  validates :status, presence: true
  validates :food_truck_id, uniqueness: { scope: :event_id, message: "has already applied to this event." }
  validates :food_truck, presence: true
  validates :event, presence: true

  validate :user_has_enough_credits, on: :create

  after_create :deduct_user_credits

  private

  def user_has_enough_credits
    user = food_truck.user
    if user.credits < event.credit_cost
      errors.add(:base, "Not enough credits to apply for this event.")
    end
  end

  def deduct_user_credits
    user = food_truck.user
    user.decrement!(:credits, event.credit_cost)
  end
end
