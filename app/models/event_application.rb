# app/models/event_application.rb
class EventApplication < ApplicationRecord
  extend FriendlyId

  belongs_to :food_truck
  belongs_to :event

  # Delegation for easier access to the user (food truck owner)
  delegate :user, to: :food_truck, prefix: true
  has_many :messages, dependent: :destroy

  # Enums
  enum status: { pending: 0, approved: 1, rejected: 2 }

  # Validations
  validates :status, presence: true
  validates :food_truck_id, uniqueness: { scope: :event_id, message: "has already applied to this event." }
  validates :food_truck, presence: true
  validates :event, presence: true

  validate :user_has_enough_credits, on: :create

  # Callbacks
  after_create :deduct_user_credits
  after_update :manage_approved_applications_count, if: :saved_change_to_status?

  after_create_commit :notify_event_organizer
  after_update_commit :notify_status_change, if: :saved_change_to_status?

  # FriendlyId Configuration
  friendly_id :slug_candidates, use: %i[slugged history finders]

  # Virtual attribute to trigger slug regeneration
  attr_accessor :regenerate_slug

  def should_generate_new_friendly_id?
    slug.blank? || regenerate_slug
  end

  private

  # Define slug candidates
  def slug_candidates
    [
      "#{event.name}-#{food_truck.name}",
      "#{event.name}-#{food_truck.name}-#{id}"
    ]
  end

  # Validation to ensure the user has enough credits
  def user_has_enough_credits
    if food_truck_user.credits < event.credit_cost
      errors.add(:base, "Not enough credits to apply for this event.")
    end
  end

  # Callback to deduct user credits after creating an application
  def deduct_user_credits
    food_truck_user.decrement!(:credits, event.credit_cost)
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, "Failed to deduct credits: #{e.message}")
    raise ActiveRecord::Rollback
  end

  # Callback to manage the count of approved applications
  def manage_approved_applications_count
    if approved? && status_before_last_save != 'approved'
      event.increment!(:approved_applications_count)
    elsif status_before_last_save == 'approved' && !approved?
      event.decrement!(:approved_applications_count)
    end

    event.update_accepting_applications!
  end

  # Email Notification Methods

  # Notify the event organizer after a new application is created
  def notify_event_organizer
    MailgunMailer.new.notify_event_organizer(
      to: event.organizer.email,
      food_truck: food_truck,
      event: event
    )
  rescue => e
    Rails.logger.error "Failed to send event organizer notification: #{e.message}"
    # Optionally, add error handling logic here
  end

  # Notify the food truck owner about status changes
  def notify_status_change
    case status
    when 'approved'
      MailgunMailer.new.send_approval_email(
        to: food_truck_user.email,
        event: event
      )
    when 'rejected'
      MailgunMailer.new.send_decline_email(
        to: food_truck_user.email,
        event: event
      )
    end
  rescue => e
    Rails.logger.error "Failed to send status change email: #{e.message}"
    # Optionally, add error handling logic here
  end
end
