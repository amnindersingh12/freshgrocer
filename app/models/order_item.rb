# frozen_string_literal: true

class OrderItem < ApplicationRecord
  # Associations
  belongs_to :order
  belongs_to :product_variant

  # Validations
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :price_at_purchase, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Calculate line total
  def line_total
    quantity * price_at_purchase
  end
end
