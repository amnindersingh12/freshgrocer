# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @featured_products = Product.joins(product_variants: :order_items)
                                .group('products.id')
                                .order('SUM(order_items.quantity) DESC')
                                .limit(6)
    @main_categories = Category.main_categories.limit(6)
  rescue ActiveRecord::StatementInvalid
    # If order_items table doesn't exist yet or has no data
    @featured_products = Product.limit(6)
    @main_categories = Category.main_categories.limit(6)
  end
end
