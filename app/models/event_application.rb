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

  validate :user_has_enough_credits, on: :create

   # Callbacks
   after_create :deduct_user_credits
   after_update :manage_approved_applications_count, if: :saved_change_to_status?

 

  private

  def user_has_enough_credits
    user = food_truck.user
    if user.credits < event.credit_cost
      errors.add(:base, "Not enough credits to apply for this event.")
    end
  end

  def deduct_user_credits
    user = food_truck.user
    user.decrement!(:credits, event.credit_cost)
  end

  def manage_approved_applications_count
    # Increment only if the current status is 'approved' and the previous status was not 'approved'
    if status == 'approved' && status_before_last_save != 'approved'
      event.increment!(:approved_applications_count)
    # Decrement only if the previous status was 'approved' and the current status is now not 'approved' (e.g., 'rejected')
    elsif status_before_last_save == 'approved' && status != 'approved' 
      event.decrement!(:approved_applications_count)
    end
  
    # Update whether the event is accepting applications based on the updated count
    event.update_accepting_applications!
  end
  
  

end
