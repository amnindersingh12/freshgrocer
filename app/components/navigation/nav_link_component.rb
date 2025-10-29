# frozen_string_literal: true

module Navigation
  class NavLinkComponent < ViewComponent::Base
    def initialize(text:, path:, current_path: nil, mobile: false)
      @text = text
      @path = path
      @current_path = current_path
      @mobile = mobile
    end

    def call
      link_to @text, @path, class: link_classes, data: link_data
    end

    private

    def link_classes
      base_class = @mobile ? "mobile-nav-link" : "nav-link"
      classes = [base_class]
      classes << "active" if active?
      classes.join(" ")
    end

    def link_data
      if @mobile
        {
          action: "click->header#handleMobileNavClick",
          header_target: "mobileNavLink"
        }
      else
        {
          action: "click->header#handleNavClick",
          header_target: "navLink",
          path: @path
        }
      end
    end

    def active?
      return false unless @current_path

      @current_path == @path ||
        (@current_path == "/" && @path == "/")
    end
  end
end
