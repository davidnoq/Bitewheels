class FoodTruck < ApplicationRecord
  belongs_to :event
  validates :cuisine, presence: true
end
