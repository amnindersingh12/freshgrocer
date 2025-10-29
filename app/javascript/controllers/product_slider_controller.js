import BaseSliderController from "./base_slider_controller"

// Connects to data-controller="product-slider"
// Extends base slider with product-specific functionality
export default class extends BaseSliderController {
    static targets = [...BaseSliderController.targets, "productName", "productPrice"]
    static values = {
        ...BaseSliderController.values,
        interval: { type: Number, default: 6000 }, // Slightly longer for products
        transition: { type: String, default: "slide" }
    }

    connect() {
        super.connect()
        this.setupProductSpecificFeatures()
    }

    disconnect() {
        super.disconnect()
    }

    // ============================================
    // Product-Specific Features
    // ============================================

    setupProductSpecificFeatures() {
        // Add animation to product text elements
        this.animateProductText(this.currentIndex)
    }

    showSlide(index, animated = true) {
        super.showSlide(index, animated)

        // Animate product text when slide changes
        if (animated) {
            this.animateProductText(index)
        }
    }

    animateProductText(index) {
        const currentSlide = this.slideTargets[index]
        if (!currentSlide) return

        const textElements = currentSlide.querySelectorAll('.slide-text-animate')

        textElements.forEach((element, i) => {
            element.style.opacity = '0'
            element.style.transform = 'translateY(20px)'

            setTimeout(() => {
                element.style.transition = 'opacity 0.6s ease-out, transform 0.6s ease-out'
                element.style.opacity = '1'
                element.style.transform = 'translateY(0)'
            }, 100 + (i * 100))
        })
    }

    // Override announceSlide to include product information
    announceSlide(index) {
        let liveRegion = this.element.querySelector('.sr-only[role="status"]')

        if (!liveRegion) {
            liveRegion = document.createElement('div')
            liveRegion.className = 'sr-only'
            liveRegion.setAttribute('role', 'status')
            liveRegion.setAttribute('aria-live', 'polite')
            liveRegion.setAttribute('aria-atomic', 'true')
            this.element.appendChild(liveRegion)
        }

        const currentSlide = this.slideTargets[index]
        const productName = currentSlide.querySelector('[data-product-name]')
        const total = this.slideTargets.length

        let announcement = `Slide ${index + 1} of ${total}`
        if (productName) {
            announcement += `. Featured product: ${productName.textContent}`
        }

        liveRegion.textContent = announcement
    }
}
