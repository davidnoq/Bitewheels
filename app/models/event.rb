class Event < ApplicationRecord
  belongs_to :user
  has_many :event_applications, dependent: :destroy
  has_many :food_trucks, through: :event_applications

  # Enums
  enum status: { draft: 0, published: 1, completed: 2}

  # Validations
  validates :name, presence: true
  validates :address, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_after_start_date
  validates :expected_attendees, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  
  validates :foodtruck_amount, presence: true
  validates :status, presence: true

  validates :latitude, numericality: true, allow_nil: true
  validates :longitude, numericality: true, allow_nil: true
  validates :credit_cost, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  
  # Scopes
  
  scope :published, -> { where(status: statuses[:published]) }
  scope :draft, -> { where(status: statuses[:draft]) }

# Callbacks
  after_update :update_accepting_applications!, if: :saved_change_to_approved_applications_count?

  # Methods
  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?
    
    if end_date < start_date
      errors.add(:end_date, "must be after the start date")
    end
  end
  
  def update_accepting_applications!
    if approved_applications_count >= foodtruck_amount
      update_columns(accepting_applications: false)
    else
      update_columns(accepting_applications: true)
    end
  end

end
