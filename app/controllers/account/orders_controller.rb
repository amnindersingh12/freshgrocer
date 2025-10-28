# frozen_string_literal: true

module Account
  class OrdersController < ApplicationController
    before_action :authenticate_user!

    def index
      @orders = current_user.orders.recent.page(params[:page]).per(10)
    end

    def show
      @order = current_user.orders.find(params[:id])
      @order_items = @order.order_items.includes(product_variant: :product)
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = 'Order not found.'
      redirect_to account_orders_path
    end
  end
end
