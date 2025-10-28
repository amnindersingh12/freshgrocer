# frozen_string_literal: true

class ProductsController < ApplicationController
  def index
    @products = Product.kept.includes(:category, :product_variants)

    # Search functionality
    @products = @products.search(params[:search]) if params[:search].present?

    # Filter by category
    @products = @products.by_category(params[:category_id]) if params[:category_id].present?

    @products = @products.page(params[:page]).per(12)
  end

  def show
    @product = Product.friendly.find(params[:slug])
    @variants = @product.product_variants.kept.in_stock
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = 'Product not found.'
    redirect_to products_path
  end
end
