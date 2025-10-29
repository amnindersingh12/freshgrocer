# frozen_string_literal: true

module Admin
  class ProductVariantsController < BaseController
    before_action :set_product
    before_action :set_variant, only: %i[show edit update destroy]

    def show; end

    def new
      @variant = @product.product_variants.build
    end

    def create
      @variant = @product.product_variants.build(variant_params)

      if @variant.save
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: [
              turbo_stream.append('variants', partial: 'admin/product_variants/variant', locals: { variant: @variant }),
              turbo_stream.prepend('flash', partial: 'shared/flash', locals: {
                                     type: 'success',
                                     message: 'Variant created successfully!'
                                   })
            ]
          end
          format.html do
            flash[:success] = 'Variant created successfully!'
            redirect_to admin_product_path(@product)
          end
        end
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @variant.update(variant_params)
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: [
              turbo_stream.replace("variant_#{@variant.id}", partial: 'admin/product_variants/variant',
                                                             locals: { variant: @variant }),
              turbo_stream.prepend('flash', partial: 'shared/flash', locals: {
                                     type: 'success',
                                     message: 'Variant updated successfully!'
                                   })
            ]
          end
          format.html do
            flash[:success] = 'Variant updated successfully!'
            redirect_to admin_product_path(@product)
          end
        end
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @variant.discarded?
        @variant.undiscard
        message = 'Variant restored successfully!'
      else
        @variant.discard
        message = 'Variant archived successfully!'
      end

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("variant_#{@variant.id}", partial: 'admin/product_variants/variant',
                                                           locals: { variant: @variant }),
            turbo_stream.prepend('flash', partial: 'shared/flash', locals: {
                                   type: 'success',
                                   message:
                                 })
          ]
        end
        format.html do
          flash[:success] = message
          redirect_to admin_product_path(@product)
        end
      end
    end

    private

    def set_product
      @product = Product.with_discarded.friendly.find(params[:product_id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = 'Product not found.'
      redirect_to admin_products_path
    end

    def set_variant
      @variant = @product.product_variants.with_discarded.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = 'Variant not found.'
      redirect_to admin_product_path(@product)
    end

    def variant_params
      params.require(:product_variant).permit(
        :sku,
        :price,
        :compare_at_price,
        :stock_quantity,
        :variant_name,
        :is_combo_deal
      )
    end
  end
end
