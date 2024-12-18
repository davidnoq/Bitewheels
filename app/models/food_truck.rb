class FoodTruck < ApplicationRecord
  extend FriendlyId
  belongs_to :user
  has_one_attached :permit
  has_many_attached :menu_files

  has_many_attached :food_images
  has_many :event_applications, dependent: :destroy
  has_many :events, through: :event_applications
  has_many :food_truck_ratings, dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :cuisine, presence: true
  validate :validate_food_images_limit
  validate :menu_files_count_within_limit
  after_update :update_event_application_slugs, if: :saved_change_to_name?
  friendly_id :name, use: %i[slugged history finders]
  def should_generate_new_friendly_id?
    will_save_change_to_name? || slug.blank?
  end



  def food_image_description_for(index)
    food_image_descriptions[index.to_s]
  end
  
  def set_food_image_description(index, description)
    self.food_image_descriptions ||= {}
    self.food_image_descriptions[index.to_s] = description
    save!
  end

  private

  def update_event_application_slugs
    event_applications.find_each do |application|
      application.regenerate_slug = true
      application.save
    end
  end
  
  def validate_food_images_limit
    if food_images.attached? && food_images.count >10
      errors.add(:food_images, "You can upload up to 10 food images.")
    end
  end

  def menu_files_count_within_limit
    if menu_files.size > 3
      errors.add(:menu_files, "You can upload up to 3 menu files.")
    end
  end
end
