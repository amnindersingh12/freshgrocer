# frozen_string_literal: true

class DeliverySlot < ApplicationRecord
  # Associations
  has_many :orders, dependent: :restrict_with_error

  # Validations
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :is_available, inclusion: { in: [true, false] }
  validate :end_time_after_start_time

  # Scopes
  scope :available, -> { where(is_available: true) }
  scope :upcoming, -> { where('start_time >= ?', Time.current).order(:start_time) }

  # Display time range
  def time_range
    "#{start_time.strftime('%B %d, %Y %I:%M %p')} - #{end_time.strftime('%I:%M %p')}"
  end

  private

  def end_time_after_start_time
    return if end_time.blank? || start_time.blank?

    return unless end_time <= start_time

    errors.add(:end_time, 'must be after start time')
  end
end
