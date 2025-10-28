# frozen_string_literal: true

class Order < ApplicationRecord
  include AASM

  # Associations
  belongs_to :user
  belongs_to :address
  belongs_to :delivery_slot
  has_many :order_items, dependent: :destroy

  # Validations
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # State machine for order status
  aasm column: 'status' do
    state :pending, initial: true
    state :processing
    state :shipped
    state :delivered
    state :cancelled

    event :process do
      transitions from: :pending, to: :processing
    end

    event :ship do
      transitions from: :processing, to: :shipped
      after do
        OrderConfirmationJob.perform_later(id, 'shipped')
      end
    end

    event :deliver do
      transitions from: :shipped, to: :delivered
      after do
        OrderConfirmationJob.perform_later(id, 'delivered')
      end
    end

    event :cancel do
      transitions from: %i[pending processing], to: :cancelled
    end
  end

  # State machine for payment status
  aasm column: 'payment_status', namespace: 'payment' do
    state :unpaid, initial: true
    state :paid
    state :refunded

    event :pay do
      transitions from: :unpaid, to: :paid
    end

    event :refund do
      transitions from: :paid, to: :refunded
    end
  end

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :last_24_hours, -> { where('created_at >= ?', 24.hours.ago) }
  scope :by_status, ->(status) { where(status:) }
  scope :by_payment_status, ->(payment_status) { where(payment_status:) }

  # Create order from cart
  def self.create_from_cart(cart, user, address, delivery_slot)
    transaction do
      order = create!(
        user:,
        address:,
        delivery_slot:,
        total_price: cart.total_price,
        status: :pending,
        payment_status: :unpaid
      )

      cart.cart_items.each do |cart_item|
        order.order_items.create!(
          product_variant: cart_item.product_variant,
          quantity: cart_item.quantity,
          price_at_purchase: cart_item.product_variant.price
        )

        # Reduce stock
        cart_item.product_variant.reduce_stock!(cart_item.quantity)
      end

      cart.clear
      order
    end
  end

  # Calculate total items
  def total_items
    order_items.sum(:quantity)
  end
end
