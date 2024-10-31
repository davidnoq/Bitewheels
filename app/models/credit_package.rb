# app/models/credit_package.rb

class CreditPackage < ApplicationRecord
    validates :name, presence: true, uniqueness: true
    validates :credits, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :price_cents, presence: true, numericality: { only_integer: true, greater_than: 0 }
  end
  
  
  