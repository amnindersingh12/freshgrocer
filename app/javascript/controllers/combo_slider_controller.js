import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["container", "slide", "prevBtn", "nextBtn"]
    static values = {
        autoplay: { type: Boolean, default: true },
        interval: { type: Number, default: 4000 }
    }

    connect() {
        this.currentIndex = 0
        this.slideWidth = 0
        this.visibleSlides = this.getVisibleSlides()
        this.autoplayTimer = null

        this.updateDimensions()
        this.updateButtons()

        if (this.autoplayValue) {
            this.startAutoplay()
        }

        // Handle window resize
        this.resizeHandler = this.handleResize.bind(this)
        window.addEventListener('resize', this.resizeHandler)

        // Pause on hover
        this.containerTarget.addEventListener('mouseenter', () => this.pauseAutoplay())
        this.containerTarget.addEventListener('mouseleave', () => this.resumeAutoplay())

        // Touch support
        this.setupTouchEvents()
    }

    disconnect() {
        this.stopAutoplay()
        window.removeEventListener('resize', this.resizeHandler)
    }

    updateDimensions() {
        if (this.slideTargets.length > 0) {
            const slide = this.slideTargets[0]
            const styles = window.getComputedStyle(slide)
            const marginRight = parseFloat(styles.marginRight)
            this.slideWidth = slide.offsetWidth + marginRight
        }
    }

    getVisibleSlides() {
        const width = window.innerWidth
        if (width >= 1280) return 4
        if (width >= 1024) return 3
        if (width >= 640) return 2
        return 1
    }

    handleResize() {
        const newVisibleSlides = this.getVisibleSlides()
        if (newVisibleSlides !== this.visibleSlides) {
            this.visibleSlides = newVisibleSlides
            this.currentIndex = 0
            this.updateDimensions()
            this.scrollToSlide(0)
            this.updateButtons()
        } else {
            this.updateDimensions()
            this.scrollToSlide(this.currentIndex)
        }
    }

    scrollToSlide(index, smooth = false) {
        const scrollPosition = index * this.slideWidth
        this.containerTarget.scrollTo({
            left: scrollPosition,
            behavior: smooth ? 'smooth' : 'auto'
        })
    }

    next() {
        const maxIndex = Math.max(0, this.slideTargets.length - this.visibleSlides)
        if (this.currentIndex < maxIndex) {
            this.currentIndex++
            this.scrollToSlide(this.currentIndex, true)
            this.updateButtons()
        }
        this.resetAutoplay()
    }

    previous() {
        if (this.currentIndex > 0) {
            this.currentIndex--
            this.scrollToSlide(this.currentIndex, true)
            this.updateButtons()
        }
        this.resetAutoplay()
    }

    updateButtons() {
        const maxIndex = Math.max(0, this.slideTargets.length - this.visibleSlides)

        if (this.hasPrevBtnTarget) {
            this.prevBtnTarget.disabled = this.currentIndex === 0
            this.prevBtnTarget.classList.toggle('opacity-50', this.currentIndex === 0)
            this.prevBtnTarget.classList.toggle('cursor-not-allowed', this.currentIndex === 0)
        }

        if (this.hasNextBtnTarget) {
            this.nextBtnTarget.disabled = this.currentIndex >= maxIndex
            this.nextBtnTarget.classList.toggle('opacity-50', this.currentIndex >= maxIndex)
            this.nextBtnTarget.classList.toggle('cursor-not-allowed', this.currentIndex >= maxIndex)
        }
    }

    startAutoplay() {
        if (!this.autoplayValue) return

        this.autoplayTimer = setInterval(() => {
            const maxIndex = Math.max(0, this.slideTargets.length - this.visibleSlides)
            if (this.currentIndex >= maxIndex) {
                this.currentIndex = 0
            } else {
                this.currentIndex++
            }
            this.scrollToSlide(this.currentIndex, true)
            this.updateButtons()
        }, this.intervalValue)
    }

    stopAutoplay() {
        if (this.autoplayTimer) {
            clearInterval(this.autoplayTimer)
            this.autoplayTimer = null
        }
    }

    pauseAutoplay() {
        this.stopAutoplay()
    }

    resumeAutoplay() {
        if (this.autoplayValue) {
            this.startAutoplay()
        }
    }

    resetAutoplay() {
        this.stopAutoplay()
        if (this.autoplayValue) {
            this.startAutoplay()
        }
    }

    setupTouchEvents() {
        let touchStartX = 0
        let touchEndX = 0

        this.containerTarget.addEventListener('touchstart', (e) => {
            touchStartX = e.changedTouches[0].screenX
        }, { passive: true })

        this.containerTarget.addEventListener('touchend', (e) => {
            touchEndX = e.changedTouches[0].screenX
            this.handleSwipe(touchStartX, touchEndX)
        }, { passive: true })
    }

    handleSwipe(startX, endX) {
        const diff = startX - endX
        const threshold = 50

        if (Math.abs(diff) > threshold) {
            if (diff > 0) {
                this.next()
            } else {
                this.previous()
            }
        }
    }

    addToCart(event) {
        event.preventDefault()
        const button = event.currentTarget
        const variantId = button.dataset.variantId

        // Add animation to button
        button.classList.add('scale-95')
        setTimeout(() => button.classList.remove('scale-95'), 150)

        // You can implement actual cart addition logic here
        console.log('Adding to cart:', variantId)
    }
}
