# app/models/food_truck_rating.rb
class FoodTruckRating < ApplicationRecord
  belongs_to :food_truck
  belongs_to :user # The event organizer who leaves the rating

  validates :rating, presence: true, inclusion: { in: 0..5 }
  validates :review, presence: true
end