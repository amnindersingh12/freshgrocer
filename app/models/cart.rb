# frozen_string_literal: true

class Cart < ApplicationRecord
  # Associations
  belongs_to :user, optional: true
  has_many :cart_items, dependent: :destroy
  has_many :product_variants, through: :cart_items

  # Validations
  validate :has_user_or_session_id

  # Find or create cart for user or session
  def self.find_or_create_for(user: nil, session_id: nil)
    if user
      find_or_create_by(user:)
    elsif session_id
      find_or_create_by(session_id:)
    else
      raise ArgumentError, 'Either user or session_id must be provided'
    end
  end

  # Merge guest cart with user cart
  def self.merge_guest_cart(user, session_id)
    return unless session_id

    guest_cart = find_by(session_id:, user_id: nil)
    return unless guest_cart

    user_cart = find_or_create_by(user:)

    guest_cart.cart_items.each do |guest_item|
      existing_item = user_cart.cart_items.find_by(product_variant_id: guest_item.product_variant_id)

      if existing_item
        existing_item.update(quantity: existing_item.quantity + guest_item.quantity)
      else
        guest_item.update(cart: user_cart)
      end
    end

    guest_cart.destroy
    user_cart
  end

  # Add item to cart
  def add_item(product_variant, quantity = 1)
    item = cart_items.find_or_initialize_by(product_variant: product_variant)
    item.quantity = (item.quantity || 0) + quantity
    item.save
  end

  # Update item quantity
  def update_item(product_variant, quantity)
    item = cart_items.find_by(product_variant:)
    return unless item

    if quantity <= 0
      item.destroy
    else
      item.update(quantity:)
    end
  end

  # Remove item from cart
  def remove_item(product_variant)
    cart_items.find_by(product_variant:)&.destroy
  end

  # Calculate total price
  def total_price
    cart_items.includes(:product_variant).sum { |item| item.quantity * item.product_variant.price }
  end

  # Get total item count
  def total_items
    cart_items.sum(:quantity)
  end

  # Check if cart is empty
  def empty?
    cart_items.none?
  end

  # Clear all items
  def clear
    cart_items.destroy_all
  end

  private

  def has_user_or_session_id
    return unless user_id.blank? && session_id.blank?

    errors.add(:base, 'Cart must belong to a user or session')
  end
end
