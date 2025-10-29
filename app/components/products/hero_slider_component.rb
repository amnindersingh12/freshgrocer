# frozen_string_literal: true

module Products
  class HeroSliderComponent < ViewComponent::Base
    def initialize(products:, interval: 6000, autoplay: true)
      @products = products.limit(5) # Limit to 5 featured products
      @interval = interval
      @autoplay = autoplay
    end

    def render?
      @products.any?
    end

    def gradient_classes
      [
        "from-blue-600 via-blue-700 to-indigo-800",
        "from-purple-600 via-purple-700 to-pink-800",
        "from-green-600 via-green-700 to-emerald-800",
        "from-orange-600 via-orange-700 to-red-800",
        "from-pink-600 via-pink-700 to-rose-800"
      ]
    end

    def product_image_url(product)
      # Placeholder for actual image URLs
      # In production, this would return product.image_url or similar
      "https://via.placeholder.com/1920x800/#{random_color}/ffffff?text=#{CGI.escape(product.name)}"
    end

    def fallback_image_url
      "https://via.placeholder.com/1920x800/cccccc/666666?text=Product+Image"
    end

    private

    def random_color
      %w[4F46E5 7C3AED 059669 EA580C EC4899].sample
    end
  end
end
