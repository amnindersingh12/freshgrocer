import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="hero-slider"
export default class extends Controller {
    static targets = ["slide", "dot"]
    static values = {
        interval: { type: Number, default: 5000 }
    }

    connect() {
        this.currentIndex = 0
        this.showSlide(this.currentIndex)
        this.startAutoplay()
    }

    disconnect() {
        this.stopAutoplay()
    }

    startAutoplay() {
        this.autoplayTimer = setInterval(() => {
            this.next()
        }, this.intervalValue)
    }

    stopAutoplay() {
        if (this.autoplayTimer) {
            clearInterval(this.autoplayTimer)
        }
    }

    next() {
        this.currentIndex = (this.currentIndex + 1) % this.slideTargets.length
        this.showSlide(this.currentIndex)
    }

    previous() {
        this.currentIndex = (this.currentIndex - 1 + this.slideTargets.length) % this.slideTargets.length
        this.showSlide(this.currentIndex)
    }

    goToSlide(event) {
        this.stopAutoplay()
        this.currentIndex = parseInt(event.currentTarget.dataset.index)
        this.showSlide(this.currentIndex)
        this.startAutoplay()
    }

    showSlide(index) {
        // Hide all slides
        this.slideTargets.forEach((slide, i) => {
            if (i === index) {
                slide.classList.remove("hidden")
                slide.classList.add("block")
            } else {
                slide.classList.remove("block")
                slide.classList.add("hidden")
            }
        })

        // Update dots
        this.dotTargets.forEach((dot, i) => {
            if (i === index) {
                dot.classList.remove("bg-white/50")
                dot.classList.add("bg-white")
            } else {
                dot.classList.remove("bg-white")
                dot.classList.add("bg-white/50")
            }
        })
    }

    pauseOnHover() {
        this.stopAutoplay()
    }

    resumeOnLeave() {
        this.startAutoplay()
    }
}
