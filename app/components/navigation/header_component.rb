# frozen_string_literal: true

module Navigation
  class HeaderComponent < ViewComponent::Base
    def initialize(current_user: nil, current_path: nil)
      @current_user = current_user
      @current_path = current_path
    end

    def navigation_links
      [
        { text: "Home", path: root_path },
        { text: "Shop", path: products_path },
        { text: "Story", path: "#story" },
        { text: "Connect", path: "#connect" }
      ]
    end

    def cart_items_count
      return 0 unless @current_user&.cart&.cart_items&.any?

      @current_user.cart.cart_items.sum(:quantity)
    end

    def user_signed_in?
      @current_user.present?
    end

    private

    def root_path
      "/"
    end

    def products_path
      "/products"
    end

    def account_profile_path
      "/account/profile"
    end

    def new_user_session_path
      "/users/sign_in"
    end

    def new_user_registration_path
      "/users/sign_up"
    end

    def destroy_user_session_path
      "/users/sign_out"
    end

    def cart_path
      "/cart"
    end
  end
end
