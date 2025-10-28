# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show]

  def index
    @orders = current_user.orders.recent.page(params[:page]).per(10)
  end

  def new
    @cart = current_cart

    if @cart.empty?
      flash[:alert] = 'Your cart is empty.'
      redirect_to root_path and return
    end

    @order = Order.new
    @addresses = current_user.addresses
    @delivery_slots = DeliverySlot.available.upcoming

    # Set current step (address, delivery, payment)
    @step = params[:step] || 'address'

    case @step
    when 'delivery'
      @selected_address = Address.find(session[:order_address_id]) if session[:order_address_id]
    when 'payment'
      @selected_address = Address.find(session[:order_address_id]) if session[:order_address_id]
      @selected_slot = DeliverySlot.find(session[:order_delivery_slot_id]) if session[:order_delivery_slot_id]
    end
  end

  def create
    @cart = current_cart

    if @cart.empty?
      flash[:alert] = 'Your cart is empty.'
      redirect_to root_path and return
    end

    # Handle multi-step checkout
    step = params[:step]

    case step
    when 'address'
      if params[:address_id].present?
        session[:order_address_id] = params[:address_id]
        redirect_to new_order_path(step: 'delivery')
      else
        flash[:alert] = 'Please select an address.'
        redirect_to new_order_path(step: 'address')
      end
    when 'delivery'
      if params[:delivery_slot_id].present?
        session[:order_delivery_slot_id] = params[:delivery_slot_id]
        redirect_to new_order_path(step: 'payment')
      else
        flash[:alert] = 'Please select a delivery slot.'
        redirect_to new_order_path(step: 'delivery')
      end
    when 'payment'
      # Process payment (mock)
      address = Address.find(session[:order_address_id])
      delivery_slot = DeliverySlot.find(session[:order_delivery_slot_id])

      begin
        @order = Order.create_from_cart(@cart, current_user, address, delivery_slot)

        # Mark as paid (mock payment success)
        @order.pay!

        # Enqueue confirmation email job
        OrderConfirmationJob.perform_later(@order.id, 'created')

        # Clear session
        session.delete(:order_address_id)
        session.delete(:order_delivery_slot_id)

        flash[:success] = 'Order placed successfully!'
        redirect_to order_path(@order)
      rescue StandardError => e
        flash[:error] = "Failed to create order: #{e.message}"
        redirect_to new_order_path(step: 'payment')
      end
    else
      redirect_to new_order_path(step: 'address')
    end
  end

  def show
    @order_items = @order.order_items.includes(product_variant: :product)
  end

  private

  def set_order
    @order = current_user.orders.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = 'Order not found.'
    redirect_to orders_path
  end
end
