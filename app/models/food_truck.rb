class FoodTruck < ApplicationRecord
  belongs_to :event
  
  # Add any necessary validations
  validates :name, presence: true
  validates :cuisine, presence: true
end
