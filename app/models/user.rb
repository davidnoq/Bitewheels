# app/models/user.rb
class User < ApplicationRecord

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
has_many :events, dependent: :destroy
has_many :food_trucks, dependent: :destroy
 ROLES = %w[user eventorganizer foodtruckowner]

  # Ensure that the role is included in the list of ROLES
  validates :role, inclusion: { in: ROLES }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: true

  validates :phone_number, phone: { possible: true, allow_blank: false }

  after_initialize :set_default_role, if: :new_record?
  
  def set_default_role
    self.role ||= 'user'  # Assign as a string
  end

  def formatted_phone_number
    phone = Phonelib.parse(phone_number, country)
    phone.full_e164.presence || phone.full_national.presence
  end
  
 # Define helper methods for roles
 ROLES.each do |role_name|
  define_method("#{role_name}?") do
    self.role == role_name
  end
end
 

end