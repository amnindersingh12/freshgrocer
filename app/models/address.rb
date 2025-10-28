# frozen_string_literal: true

class Address < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :orders, dependent: :restrict_with_error

  # Validations
  validates :street, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip_code, presence: true
  validates :country, presence: true

  # Scopes
  scope :default, -> { where(is_default: true) }

  # Callbacks
  before_save :ensure_single_default

  # Display full address
  def full_address
    "#{street}, #{city}, #{state} #{zip_code}, #{country}"
  end

  # Set this address as the default
  def set_as_default!
    transaction do
      user.addresses.where.not(id:).update_all(is_default: false)
      update!(is_default: true)
    end
  end

  private

  # Ensure only one default address per user
  def ensure_single_default
    return unless is_default_changed? && is_default?

    self.class.where(user_id:).where.not(id:).update_all(is_default: false)
  end
end
