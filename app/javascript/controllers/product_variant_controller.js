import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="product-variant"
export default class extends Controller {
    static targets = ["price", "select", "addToCart", "stock"]
    static values = { variants: Object }

    connect() {
        this.updatePrice()
    }

    updatePrice() {
        const selectedVariantId = this.selectTarget.value

        if (selectedVariantId && this.variantsValue[selectedVariantId]) {
            const variant = this.variantsValue[selectedVariantId]
            this.priceTarget.textContent = `$${parseFloat(variant.price).toFixed(2)}`

            // Update stock display
            if (this.hasStockTarget) {
                this.stockTarget.textContent = variant.stock_quantity
            }

            // Update add to cart button
            if (this.hasAddToCartTarget) {
                if (variant.stock_quantity > 0) {
                    this.addToCartTarget.disabled = false
                    this.addToCartTarget.classList.remove('opacity-50', 'cursor-not-allowed')
                    this.addToCartTarget.textContent = 'Add to Cart'
                } else {
                    this.addToCartTarget.disabled = true
                    this.addToCartTarget.classList.add('opacity-50', 'cursor-not-allowed')
                    this.addToCartTarget.textContent = 'Out of Stock'
                }
            }
        }
    }

    change(event) {
        this.updatePrice()
    }
}
