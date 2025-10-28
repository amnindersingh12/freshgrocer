# frozen_string_literal: true

module Admin
  class CategoriesController < BaseController
    before_action :set_category, only: %i[edit update destroy]

    def index
      @main_categories = Category.main_categories.includes(:sub_categories)
    end

    def new
      @category = Category.new
      @categories = Category.main_categories
    end

    def create
      @category = Category.new(category_params)

      if @category.save
        flash[:success] = 'Category created successfully!'
        redirect_to admin_categories_path
      else
        @categories = Category.main_categories
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @categories = Category.main_categories.where.not(id: @category.id)
    end

    def update
      if @category.update(category_params)
        flash[:success] = 'Category updated successfully!'
        redirect_to admin_categories_path
      else
        @categories = Category.main_categories.where.not(id: @category.id)
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @category.products.none? && @category.sub_categories.none?
        @category.destroy
        flash[:success] = 'Category deleted successfully!'
      else
        flash[:alert] = 'Cannot delete category with products or sub-categories.'
      end
      redirect_to admin_categories_path
    end

    private

    def set_category
      @category = Category.friendly.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = 'Category not found.'
      redirect_to admin_categories_path
    end

    def category_params
      params.require(:category).permit(:name, :parent_id)
    end
  end
end
