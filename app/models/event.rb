class Event < ApplicationRecord
  belongs_to :user
  has_many :event_applications, dependent: :destroy
  has_many :food_trucks, through: :event_applications

  # Enums
  enum status: { draft: 0, published: 1 }

  # Validations
  validates :name, presence: true
  validates :address, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :expected_attendees, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  
  validates :foodtruck_amount, presence: true
  validates :status, presence: true

  validates :latitude, numericality: true, allow_nil: true
  validates :longitude, numericality: true, allow_nil: true
  validates :credit_cost, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Scopes
  scope :published, -> { where(status: statuses[:published]) }
  scope :draft, -> { where(status: statuses[:draft]) }
end
