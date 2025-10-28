# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Role-based authorization
  enum role: { customer: 0, admin: 1 }

  # Associations
  has_many :orders, dependent: :destroy
  has_many :addresses, dependent: :destroy
  has_many :carts, dependent: :destroy

  # Validations
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :role, presence: true
  validates :phone, format: { with: /\A\+?\d[\d\s\-()]*\z/, message: 'must be a valid phone number' }, allow_blank: true

  # Helper methods
  def full_name
    if first_name.present? || last_name.present?
      "#{first_name} #{last_name}".strip
    else
      name
    end
  end

  def default_address
    addresses.find_by(is_default: true) || addresses.first
  end

  # Set default role
  after_initialize :set_default_role, if: :new_record?

  private

  def set_default_role
    self.role ||= :customer
  end
end
