import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="animate"
// Provides gentle, eye-friendly animations with stagger and reduced-motion support
export default class extends Controller {
    static values = {
        delay: { type: Number, default: 0 },
        stagger: { type: Number, default: 150 }, // ms between items
        animation: { type: String, default: 'fade-up' }
    }

    connect() {
        // Check if user prefers reduced motion
        this.prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches

        if (this.prefersReducedMotion) {
            // Skip animations if user prefers reduced motion
            this.element.style.opacity = '1'
            this.element.style.transform = 'none'
            return
        }

        // Set initial state
        this.element.style.opacity = '0'

        if (this.animationValue === 'fade-up') {
            this.element.style.transform = 'translateY(10px)'
        }

        // Observe when element enters viewport
        this.observer = new IntersectionObserver(
            (entries) => this.handleIntersection(entries),
            {
                threshold: 0.1,
                rootMargin: '0px 0px -50px 0px'
            }
        )

        this.observer.observe(this.element)
    }

    disconnect() {
        if (this.observer) {
            this.observer.disconnect()
        }
    }

    handleIntersection(entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                this.animate()
                this.observer.unobserve(this.element)
            }
        })
    }

    animate() {
        const delay = this.delayValue

        setTimeout(() => {
            this.element.style.transition = 'all 0.6s cubic-bezier(0.4, 0, 0.2, 1)'
            this.element.style.opacity = '1'
            this.element.style.transform = 'translateY(0)'

            // Add animation class
            this.element.classList.add(`animate-${this.animationValue}`)
        }, delay)
    }

    // Static method to stagger multiple elements
    static stagger(elements, baseDelay = 0, staggerDelay = 150) {
        elements.forEach((element, index) => {
            const delay = baseDelay + (index * staggerDelay)
            element.setAttribute('data-animate-delay-value', delay)
        })
    }
}
