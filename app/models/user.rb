# app/models/user.rb
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Defining roles using enum
  enum role: { user: 0, eventorganizer: 1, foodtruckowner: 2 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: true

  after_initialize :set_default_role, if: :new_record?

  def set_default_role
    self.role ||= :user
  end

  validates :phone_number, phone: {possible: true, allow_blank: false}

  def formatted_phone_number
      phone = Phonelib.parse(phone_number)
      formatted = phone.full_e164.presence || phone.full_national.presence
  end

end
