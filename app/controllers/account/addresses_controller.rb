# frozen_string_literal: true

module Account
  class AddressesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_address, only: %i[edit update destroy set_default]

    def index
      @addresses = current_user.addresses
    end

    def new
      @address = current_user.addresses.build
    end

    def create
      @address = current_user.addresses.build(address_params)

      if @address.save
        flash[:success] = 'Address created successfully!'
        redirect_to account_addresses_path
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @address.update(address_params)
        flash[:success] = 'Address updated successfully!'
        redirect_to account_addresses_path
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @address.orders.none?
        @address.destroy
        flash[:success] = 'Address deleted successfully!'
      else
        flash[:alert] = 'Cannot delete address with existing orders.'
      end
      redirect_to account_addresses_path
    end

    def set_default
      @address.set_as_default!
      flash[:success] = 'Default address updated successfully!'
      redirect_to account_addresses_path
    rescue StandardError => e
      flash[:alert] = "Failed to set default address: #{e.message}"
      redirect_to account_addresses_path
    end

    private

    def set_address
      @address = current_user.addresses.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = 'Address not found.'
      redirect_to account_addresses_path
    end

    def address_params
      params.require(:address).permit(:street, :city, :state, :zip_code, :country, :is_default)
    end
  end
end
