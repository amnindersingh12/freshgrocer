# frozen_string_literal: true

class CartsController < ApplicationController
  before_action :set_cart

  def show
    @cart_items = @cart.cart_items.includes(product_variant: :product)
  end

  def add_item
    variant = ProductVariant.find(params[:product_variant_id])
    quantity = [params[:quantity].to_i, 1].max

    if variant.has_stock?(quantity)
      @cart.add_item(variant, quantity)

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace('cart', partial: 'carts/cart', locals: { cart: @cart }),
            turbo_stream.replace('cart-icon', partial: 'shared/cart_icon'),
            turbo_stream.prepend('flash', partial: 'shared/flash', locals: {
                                   type: 'success',
                                   message: "Added #{quantity} × #{variant.product.name} (#{variant.variant_name}) to cart!"
                                 })
          ]
        end
        format.html do
          flash[:success] = "Added #{quantity} item(s) to cart!"
          redirect_back(fallback_location: root_path)
        end
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.prepend('flash', partial: 'shared/flash', locals: {
                                                      type: 'error',
                                                      message: 'Insufficient stock available.'
                                                    })
        end
        format.html do
          flash[:error] = 'Insufficient stock available.'
          redirect_back(fallback_location: root_path)
        end
      end
    end
  end

  def update_item
    variant = ProductVariant.find(params[:product_variant_id])
    quantity = params[:quantity].to_i

    @cart.update_item(variant, quantity)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace('cart', partial: 'carts/cart', locals: { cart: @cart }),
          turbo_stream.replace('cart-icon', partial: 'shared/cart_icon')
        ]
      end
      format.html do
        flash[:success] = 'Cart updated!'
        redirect_to cart_path
      end
    end
  end

  def remove_item
    variant = ProductVariant.find(params[:product_variant_id])
    @cart.remove_item(variant)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace('cart', partial: 'carts/cart', locals: { cart: @cart }),
          turbo_stream.replace('cart-icon', partial: 'shared/cart_icon')
        ]
      end
      format.html do
        flash[:success] = 'Item removed from cart!'
        redirect_to cart_path
      end
    end
  end

  private

  def set_cart
    @cart = current_cart
  end
end
