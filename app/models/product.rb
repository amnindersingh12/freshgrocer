# frozen_string_literal: true

class Product < ApplicationRecord
  include Discard::Model

  extend FriendlyId
  friendly_id :name, use: :slugged

  # Associations
  belongs_to :category
  has_many :product_variants, dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :description, presence: true
  validates :brand, presence: true
  validates :slug, uniqueness: true

  # Scopes
  default_scope -> { kept }
  scope :by_category, ->(category_id) { where(category_id:) }
  scope :search, lambda { |query|
    where('name ILIKE ? OR description ILIKE ? OR brand ILIKE ?',
          "%#{query}%", "%#{query}%", "%#{query}%")
  }

  # Calculate total stock across all variants
  def total_stock
    product_variants.kept.sum(:stock_quantity)
  end

  # Check if product has stock available
  def in_stock?
    total_stock > 0
  end

  def should_generate_new_friendly_id?
    name_changed? || super
  end
end
