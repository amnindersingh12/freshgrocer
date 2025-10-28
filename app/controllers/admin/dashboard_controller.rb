# frozen_string_literal: true

module Admin
  class DashboardController < BaseController
    def index
      # Total sales (paid orders)
      @total_sales = Order.where(payment_status: :paid).sum(:total_price)

      # New orders in last 24 hours
      @new_orders_count = Order.last_24_hours.count

      # Total products count
      @products_count = Product.kept.count

      # Top 5 products by sales (through product_variants)
      @top_products = Product.joins(product_variants: :order_items)
                             .select('products.*, SUM(order_items.quantity) as total_sold, SUM(order_items.quantity * order_items.price_at_purchase) as revenue')
                             .group('products.id')
                             .order('total_sold DESC')
                             .limit(5)

      # New user signups (last 30 days)
      @new_customers_count = User.where(role: :customer).where('created_at >= ?', 30.days.ago).count

      # Recent orders
      @recent_orders = Order.includes(:user).recent.limit(10)
    rescue ActiveRecord::StatementInvalid
      # Fallback if no orders exist yet
      @total_sales = 0
      @new_orders_count = 0
      @products_count = Product.kept.count
      @top_products = []
      @new_customers_count = 0
      @recent_orders = []
    end
  end
end
