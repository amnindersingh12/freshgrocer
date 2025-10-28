# frozen_string_literal: true

module Admin
  class OrdersController < BaseController
    before_action :set_order, only: %i[show update]

    def index
      @orders = Order.includes(:user).recent

      # Search by customer name or order ID
      if params[:search].present?
        @orders = @orders.joins(:user)
                         .where('users.name ILIKE ? OR orders.id::text ILIKE ?',
                                "%#{params[:search]}%", "%#{params[:search]}%")
      end

      # Filter by status
      @orders = @orders.by_status(params[:status]) if params[:status].present?

      # Filter by payment status
      @orders = @orders.by_payment_status(params[:payment_status]) if params[:payment_status].present?

      @orders = @orders.page(params[:page]).per(20)
    end

    def show
      @order_items = @order.order_items.includes(product_variant: :product)
    end

    def update
      # Update order status or payment status
      if params[:order][:status].present?
        new_status = params[:order][:status]

        case new_status
        when 'processing'
          @order.process! if @order.may_process?
        when 'shipped'
          @order.ship! if @order.may_ship?
        when 'delivered'
          @order.deliver! if @order.may_deliver?
        when 'cancelled'
          @order.cancel! if @order.may_cancel?
        end

        flash[:success] = 'Order status updated successfully!'
      elsif params[:order][:payment_status].present?
        new_payment_status = params[:order][:payment_status]

        case new_payment_status
        when 'paid'
          @order.pay! if @order.may_pay?
        when 'refunded'
          @order.refund! if @order.may_refund?
        end

        flash[:success] = 'Payment status updated successfully!'
      end

      redirect_to admin_order_path(@order)
    rescue AASM::InvalidTransition => e
      flash[:error] = "Invalid status transition: #{e.message}"
      redirect_to admin_order_path(@order)
    end

    private

    def set_order
      @order = Order.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = 'Order not found.'
      redirect_to admin_orders_path
    end
  end
end
