class FoodTruck < ApplicationRecord
  belongs_to :event
  belongs_to :user

  validates :cuisine, presence: true
  #cannot apply to an event twice
  validates :event_id, uniqueness: { scope: :user_id, message: "You have already applied to this event." }
end
