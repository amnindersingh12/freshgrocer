# frozen_string_literal: true

class CategoriesController < ApplicationController
  def index
    @main_categories = Category.main_categories
  end

  def show
    @category = Category.friendly.find(params[:slug])
    @sub_categories = @category.sub_categories
    @products = @category.products.kept.includes(:product_variants).page(params[:page]).per(12)

    # Filter by sub-category
    if params[:sub_category_id].present?
      sub_category = Category.find(params[:sub_category_id])
      @products = sub_category.products.kept.includes(:product_variants).page(params[:page]).per(12)
    end
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = 'Category not found.'
    redirect_to categories_path
  end
end
