class FoodTruck < ApplicationRecord
  belongs_to :user
  has_one_attached :permit

  has_many_attached :menu_images
  has_many_attached :food_images

  has_many :event_applications, dependent: :destroy
  has_many :events, through: :event_applications

  # Validations
  validates :name, presence: true
  validates :cuisine, presence: true
  validate :validate_food_images_limit
  validate :validate_menu_images_limit

  private

  def validate_food_images_limit
    if food_images.attached? && food_images.count > 2
      errors.add(:food_images, "You can upload up to 2 food images.")
    end
  end

  def validate_menu_images_limit
    if menu_images.attached? && menu_images.count > 3
      errors.add(:menu_images, "You can upload up to 3 food images.")
    end
  end
end
