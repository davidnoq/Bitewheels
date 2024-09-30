class Event < ApplicationRecord
    # Association with EventOrganizer
    belongs_to :organizer, class_name: 'EventOrganizer'  # Assuming EventOrganizer is the model for event organizers
  
    # Validations
    validates :name, presence: true
    validates :location, presence: true
    validates :date, presence: true
    validates :expected_attendees, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :description, presence: true  # Ensure description is present
    has_many :food_trucks, dependent: :destroy
    accepts_nested_attributes_for :food_trucks, allow_destroy: true
    # If using Active Storage for image uploads
    has_one_attached :logo  # For the event logo
  end
  