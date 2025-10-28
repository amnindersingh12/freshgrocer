# frozen_string_literal: true

module Admin
  class ProductsController < BaseController
    before_action :set_product, only: %i[show edit update destroy]

    def index
      @products = Product.with_discarded.includes(:category, :product_variants)
                         .page(params[:page]).per(20)
    end

    def show
      @variants = @product.product_variants.with_discarded
    end

    def new
      @product = Product.new
      @categories = Category.all
    end

    def create
      @product = Product.new(product_params)

      if @product.save
        flash[:success] = 'Product created successfully!'
        redirect_to admin_product_path(@product)
      else
        @categories = Category.all
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @categories = Category.all
    end

    def update
      if @product.update(product_params)
        flash[:success] = 'Product updated successfully!'
        redirect_to admin_product_path(@product)
      else
        @categories = Category.all
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @product.discarded?
        @product.undiscard
        flash[:success] = 'Product restored successfully!'
      else
        @product.discard
        flash[:success] = 'Product archived successfully!'
      end
      redirect_to admin_products_path
    end

    private

    def set_product
      @product = Product.with_discarded.friendly.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = 'Product not found.'
      redirect_to admin_products_path
    end

    def product_params
      params.require(:product).permit(:name, :description, :brand, :category_id)
    end
  end
end
