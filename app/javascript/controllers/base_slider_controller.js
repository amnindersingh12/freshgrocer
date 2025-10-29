import { Controller } from "@hotwired/stimulus"

// Base Slider Controller - Shared functionality for hero sliders
export default class extends Controller {
    static targets = ["slide", "dot", "prevButton", "nextButton"]
    static values = {
        interval: { type: Number, default: 5000 },
        autoplay: { type: Boolean, default: true },
        pauseOnHover: { type: Boolean, default: true },
        transition: { type: String, default: "fade" } // 'fade' or 'slide'
    }

    connect() {
        this.currentIndex = 0
        this.isPaused = false
        this.touchStartX = 0
        this.touchEndX = 0

        // Initialize
        this.showSlide(this.currentIndex, false)

        // Setup event listeners
        this.setupKeyboardNavigation()
        this.setupTouchEvents()

        // Start autoplay if enabled
        if (this.autoplayValue) {
            this.startAutoplay()
        }

        // Announce initial slide to screen readers
        this.announceSlide(this.currentIndex)
    }

    disconnect() {
        this.stopAutoplay()
        this.removeKeyboardNavigation()
        this.removeTouchEvents()
    }

    // ============================================
    // Autoplay Controls
    // ============================================

    startAutoplay() {
        if (!this.autoplayValue || this.isPaused) return

        this.stopAutoplay()
        this.autoplayTimer = setInterval(() => {
            this.next()
        }, this.intervalValue)
    }

    stopAutoplay() {
        if (this.autoplayTimer) {
            clearInterval(this.autoplayTimer)
            this.autoplayTimer = null
        }
    }

    pauseOnHover() {
        if (!this.pauseOnHoverValue) return
        this.isPaused = true
        this.stopAutoplay()
    }

    resumeOnLeave() {
        if (!this.pauseOnHoverValue) return
        this.isPaused = false
        this.startAutoplay()
    }

    // ============================================
    // Navigation Methods
    // ============================================

    next(event) {
        if (event) event.preventDefault()
        this.currentIndex = (this.currentIndex + 1) % this.slideTargets.length
        this.showSlide(this.currentIndex)
        this.announceSlide(this.currentIndex)
    }

    previous(event) {
        if (event) event.preventDefault()
        this.currentIndex = (this.currentIndex - 1 + this.slideTargets.length) % this.slideTargets.length
        this.showSlide(this.currentIndex)
        this.announceSlide(this.currentIndex)
    }

    goToSlide(event) {
        event.preventDefault()
        this.stopAutoplay()
        this.currentIndex = parseInt(event.currentTarget.dataset.index)
        this.showSlide(this.currentIndex)
        this.announceSlide(this.currentIndex)

        if (this.autoplayValue && !this.isPaused) {
            this.startAutoplay()
        }
    }

    // ============================================
    // Slide Display Logic
    // ============================================

    showSlide(index, animated = true) {
        if (!this.hasSlideTarget) return

        const transition = this.transitionValue

        this.slideTargets.forEach((slide, i) => {
            if (i === index) {
                // Show slide with animation
                slide.classList.remove("hidden")
                slide.setAttribute("aria-hidden", "false")

                if (animated) {
                    if (transition === "fade") {
                        this.fadeIn(slide)
                    } else if (transition === "slide") {
                        this.slideIn(slide)
                    }
                } else {
                    slide.classList.add("block")
                    slide.style.opacity = "1"
                }

                // Lazy load images
                this.lazyLoadImages(slide)
            } else {
                // Hide slide
                slide.classList.remove("block")
                slide.classList.add("hidden")
                slide.setAttribute("aria-hidden", "true")
                slide.style.opacity = "0"
            }
        })

        // Update dots
        if (this.hasDotTarget) {
            this.dotTargets.forEach((dot, i) => {
                if (i === index) {
                    dot.classList.remove("bg-white/50", "scale-100")
                    dot.classList.add("bg-white", "scale-125")
                    dot.setAttribute("aria-current", "true")
                } else {
                    dot.classList.remove("bg-white", "scale-125")
                    dot.classList.add("bg-white/50", "scale-100")
                    dot.removeAttribute("aria-current")
                }
            })
        }

        // Update button states
        this.updateButtonStates()
    }

    // ============================================
    // Animation Methods
    // ============================================

    fadeIn(slide) {
        slide.style.opacity = "0"
        slide.classList.add("block")

        requestAnimationFrame(() => {
            slide.style.transition = "opacity 0.6s ease-in-out"
            slide.style.opacity = "1"
        })
    }

    slideIn(slide) {
        slide.style.transform = "translateX(100%)"
        slide.style.opacity = "0"
        slide.classList.add("block")

        requestAnimationFrame(() => {
            slide.style.transition = "transform 0.6s cubic-bezier(0.4, 0, 0.2, 1), opacity 0.6s ease-in-out"
            slide.style.transform = "translateX(0)"
            slide.style.opacity = "1"
        })
    }

    // ============================================
    // Lazy Loading
    // ============================================

    lazyLoadImages(slide) {
        const images = slide.querySelectorAll('img[data-src]')

        images.forEach(img => {
            if (!img.src || img.src === img.dataset.placeholder) {
                img.src = img.dataset.src
                img.removeAttribute('data-src')

                img.onerror = () => {
                    // Use fallback if image fails to load
                    if (img.dataset.fallback) {
                        img.src = img.dataset.fallback
                    }
                }
            }
        })
    }

    // ============================================
    // Keyboard Navigation
    // ============================================

    setupKeyboardNavigation() {
        this.keyboardHandler = this.handleKeyboard.bind(this)
        document.addEventListener('keydown', this.keyboardHandler)
    }

    removeKeyboardNavigation() {
        if (this.keyboardHandler) {
            document.removeEventListener('keydown', this.keyboardHandler)
        }
    }

    handleKeyboard(event) {
        // Only handle if slider is in viewport
        if (!this.isInViewport()) return

        switch (event.key) {
            case 'ArrowLeft':
                event.preventDefault()
                this.previous()
                break
            case 'ArrowRight':
                event.preventDefault()
                this.next()
                break
            case 'Home':
                event.preventDefault()
                this.currentIndex = 0
                this.showSlide(this.currentIndex)
                this.announceSlide(this.currentIndex)
                break
            case 'End':
                event.preventDefault()
                this.currentIndex = this.slideTargets.length - 1
                this.showSlide(this.currentIndex)
                this.announceSlide(this.currentIndex)
                break
        }
    }

    // ============================================
    // Touch/Swipe Support
    // ============================================

    setupTouchEvents() {
        this.element.addEventListener('touchstart', this.handleTouchStart.bind(this), { passive: true })
        this.element.addEventListener('touchend', this.handleTouchEnd.bind(this), { passive: true })
    }

    removeTouchEvents() {
        this.element.removeEventListener('touchstart', this.handleTouchStart)
        this.element.removeEventListener('touchend', this.handleTouchEnd)
    }

    handleTouchStart(event) {
        this.touchStartX = event.changedTouches[0].screenX
        this.pauseOnHover()
    }

    handleTouchEnd(event) {
        this.touchEndX = event.changedTouches[0].screenX
        this.handleSwipe()
        this.resumeOnLeave()
    }

    handleSwipe() {
        const swipeThreshold = 50
        const diff = this.touchStartX - this.touchEndX

        if (Math.abs(diff) > swipeThreshold) {
            if (diff > 0) {
                // Swiped left - go to next
                this.next()
            } else {
                // Swiped right - go to previous
                this.previous()
            }
        }
    }

    // ============================================
    // Accessibility
    // ============================================

    announceSlide(index) {
        // Create or update live region for screen readers
        let liveRegion = this.element.querySelector('.sr-only[role="status"]')

        if (!liveRegion) {
            liveRegion = document.createElement('div')
            liveRegion.className = 'sr-only'
            liveRegion.setAttribute('role', 'status')
            liveRegion.setAttribute('aria-live', 'polite')
            liveRegion.setAttribute('aria-atomic', 'true')
            this.element.appendChild(liveRegion)
        }

        const total = this.slideTargets.length
        liveRegion.textContent = `Slide ${index + 1} of ${total}`
    }

    updateButtonStates() {
        // Update ARIA labels for navigation buttons
        if (this.hasPrevButtonTarget) {
            this.prevButtonTarget.setAttribute('aria-label',
                `Previous slide (${this.currentIndex === 0 ? this.slideTargets.length : this.currentIndex} of ${this.slideTargets.length})`
            )
        }

        if (this.hasNextButtonTarget) {
            this.nextButtonTarget.setAttribute('aria-label',
                `Next slide (${this.currentIndex + 2 > this.slideTargets.length ? 1 : this.currentIndex + 2} of ${this.slideTargets.length})`
            )
        }
    }

    // ============================================
    // Utility Methods
    // ============================================

    isInViewport() {
        const rect = this.element.getBoundingClientRect()
        return (
            rect.top >= 0 &&
            rect.left >= 0 &&
            rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) &&
            rect.right <= (window.innerWidth || document.documentElement.clientWidth)
        )
    }
}
