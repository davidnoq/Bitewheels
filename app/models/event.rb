class Event < ApplicationRecord
  has_many :food_trucks, dependent: :destroy
  accepts_nested_attributes_for :food_trucks, allow_destroy: true

  validates :name, presence: true
  validates :location, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :expected_attendees, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :logo, format: { with: /\.(png|jpe?g|gif)\z/i, message: "must be a URL for GIF, JPG or PNG image." }, allow_blank: true
  validates :description, presence: true
  validates :foodtruck_amount, presence: true
end
