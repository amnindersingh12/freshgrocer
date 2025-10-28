# frozen_string_literal: true

class CartItem < ApplicationRecord
  # Associations
  belongs_to :cart
  belongs_to :product_variant

  # Validations
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :product_variant_id, uniqueness: { scope: :cart_id }
  validate :product_variant_has_stock

  # Calculate line total
  def line_total
    quantity * product_variant.price
  end

  private

  def product_variant_has_stock
    return if product_variant.blank?

    return if product_variant.has_stock?(quantity)

    errors.add(:quantity, "exceeds available stock (#{product_variant.stock_quantity} available)")
  end
end
