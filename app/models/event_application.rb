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
end
