# frozen_string_literal: true

class Category < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  # Self-referential association for parent/sub-categories
  belongs_to :parent, class_name: 'Category', optional: true
  has_many :sub_categories, class_name: 'Category', foreign_key: 'parent_id', dependent: :destroy

  # Products association
  has_many :products, dependent: :destroy

  # Validations
  validates :name, presence: true, uniqueness: { scope: :parent_id }
  validates :slug, uniqueness: true

  # Scopes
  scope :main_categories, -> { where(parent_id: nil) }
  scope :sub_categories, -> { where.not(parent_id: nil) }

  def should_generate_new_friendly_id?
    name_changed? || super
  end
end
