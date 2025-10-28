# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_current_cart

  helper_method :current_cart

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  # Authorization helper
  def authorize_admin!
    return if current_user&.admin?

    flash[:alert] = 'You are not authorized to access this page.'
    redirect_to root_path
  end

  # Get or create cart for current user or guest session
  def current_cart
    @current_cart ||= if user_signed_in?
                        # Merge guest cart if exists
                        Cart.merge_guest_cart(current_user, session.id.to_s)
                        Cart.find_or_create_for(user: current_user)
                      else
                        Cart.find_or_create_for(session_id: session.id.to_s)
                      end
  end

  def set_current_cart
    current_cart
  end
end
