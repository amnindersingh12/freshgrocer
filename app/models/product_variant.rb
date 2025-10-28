# frozen_string_literal: true

class ProductVariant < ApplicationRecord
  include Discard::Model

  # Associations
  belongs_to :product
  has_many :cart_items, dependent: :destroy
  has_many :order_items, dependent: :restrict_with_error

  # Validations
  validates :sku, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock_quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :variant_name, presence: true

  # Scopes
  default_scope -> { kept }
  scope :in_stock, -> { where('stock_quantity > 0') }
  scope :out_of_stock, -> { where(stock_quantity: 0) }

  # Check if variant has sufficient stock
  def has_stock?(quantity = 1)
    stock_quantity >= quantity
  end

  # Reduce stock quantity
  def reduce_stock!(quantity)
    update!(stock_quantity: stock_quantity - quantity)
  end

  # Display name with variant
  def display_name
    "#{product.name} - #{variant_name}"
  end
end
