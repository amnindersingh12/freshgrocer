import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="header"
export default class extends Controller {
    static targets = [
        "header",
        "mobileMenu",
        "mobileMenuOverlay",
        "searchModal",
        "searchOverlay",
        "searchInput",
        "navLinks",
        "navLink",
        "indicator",
        "mobileNavLinks",
        "mobileNavLink",
        "navWrapper"
    ]

    connect() {
        this.lastScrollTop = 0
        this.scrollThreshold = 10
        this.isScrollingDown = false
        this.headerHeight = this.headerTarget.offsetHeight
        this.isScrolling = false
        this.scrollTimer = null

        // Throttle scroll events for better performance
        this.throttleDelay = 10

        // Add initial load animation
        this.animateHeaderOnLoad()

        // Initialize active link indicator
        this.initializeActiveLink()

        // Set up resize observer for responsive indicator
        this.setupResizeObserver()

        // Handle hash on page load (after Turbo navigation)
        this.handleHashOnLoad()
    }

    // ============================================
    // Handle Hash on Page Load
    // ============================================
    handleHashOnLoad() {
        // Wait for page to fully load and Turbo to settle
        setTimeout(() => {
            if (window.location.hash) {
                this.smoothScrollToSection(window.location.hash)
            }
        }, 300)
    }

    // ============================================
    // Initial Load Animation - Calm fade-in
    // ============================================
    animateHeaderOnLoad() {
        // Simple calm fade-in, no bouncing
        this.headerTarget.style.opacity = '0'

        requestAnimationFrame(() => {
            setTimeout(() => {
                this.headerTarget.style.opacity = '1'
                this.headerTarget.style.transition = 'opacity 0.3s ease'
            }, 100)
        })
    }

    // ============================================
    // Active Link Indicator System
    // ============================================
    initializeActiveLink() {
        if (!this.hasIndicatorTarget) return

        // Find the current active link based on URL
        const currentPath = window.location.pathname
        const activeLink = this.navLinkTargets.find(link => {
            const href = link.getAttribute('href')
            return href === currentPath || (currentPath === '/' && href === currentPath)
        })

        if (activeLink) {
            this.setActiveLink(activeLink, false)
        } else if (this.navLinkTargets.length > 0) {
            // Default to first link if no match
            this.setActiveLink(this.navLinkTargets[0], false)
        }

        // Set active state for mobile nav
        this.updateMobileActiveState()
    }

    setActiveLink(link, animated = true) {
        if (!this.hasIndicatorTarget || !link) return

        // Remove active class from all links
        this.navLinkTargets.forEach(l => l.classList.remove('active'))

        // Add active class to clicked link
        link.classList.add('active')

        // Animate indicator to active link
        this.moveIndicatorToLink(link, animated)
    }

    moveIndicatorToLink(link, animated = true) {
        if (!this.hasIndicatorTarget) return

        const linkRect = link.getBoundingClientRect()
        const navRect = this.navLinksTarget.getBoundingClientRect()

        const left = linkRect.left - navRect.left
        const width = linkRect.width

        if (!animated) {
            this.indicatorTarget.style.transition = 'none'
        } else {
            // Calm transition, no bounce
            this.indicatorTarget.style.transition = 'left 0.3s ease, width 0.3s ease'
        }

        this.indicatorTarget.style.left = `${left}px`
        this.indicatorTarget.style.width = `${width}px`
        this.indicatorTarget.style.opacity = '1'

        // Force reflow to enable transition on next change
        if (!animated) {
            void this.indicatorTarget.offsetWidth
            this.indicatorTarget.style.transition = 'left 0.3s ease, width 0.3s ease'
        }
    }

    setupResizeObserver() {
        if (!this.hasIndicatorTarget) return

        const resizeObserver = new ResizeObserver(() => {
            const activeLink = this.navLinkTargets.find(link => link.classList.contains('active'))
            if (activeLink) {
                this.moveIndicatorToLink(activeLink, false)
            }
        })

        if (this.hasNavWrapperTarget) {
            resizeObserver.observe(this.navWrapperTarget)
        }
    }

    updateMobileActiveState() {
        const currentPath = window.location.pathname

        this.mobileNavLinkTargets.forEach(link => {
            link.classList.remove('active')
            const href = link.getAttribute('href')
            if (href === currentPath || (currentPath === '/' && href === currentPath)) {
                link.classList.add('active')
            }
        })
    }

    // ============================================
    // Nav Link Click Handler with Smooth Scroll
    // ============================================
    handleNavClick(event) {
        const link = event.currentTarget
        const href = link.getAttribute('href')

        // Set active state
        this.setActiveLink(link, true)

        // Handle hash links with smooth scroll
        if (href.includes('#')) {
            // Check if we're navigating to a different page with an anchor
            const [path, hash] = href.split('#')
            const currentPath = window.location.pathname

            // If we're on the same page or going to root with hash
            if (!path || path === currentPath || (path === '/' && currentPath === '/')) {
                event.preventDefault()
                this.smoothScrollToSection('#' + hash)
            }
            // Otherwise, let the browser navigate normally (Turbo will handle it)
        }
    }

    handleMobileNavClick(event) {
        const link = event.currentTarget
        const href = link.getAttribute('href')

        // Update active state
        this.mobileNavLinkTargets.forEach(l => l.classList.remove('active'))
        link.classList.add('active')

        // Center the active item in view on mobile
        this.centerMobileNavItem(link)

        // Handle hash links with smooth scroll
        if (href.includes('#')) {
            const [path, hash] = href.split('#')
            const currentPath = window.location.pathname

            // If we're on the same page or going to root with hash
            if (!path || path === currentPath || (path === '/' && currentPath === '/')) {
                event.preventDefault()
                this.smoothScrollToSection('#' + hash)

                // Close menu after short delay
                setTimeout(() => {
                    this.closeMobileMenu()
                }, 300)
            } else {
                // Close menu for navigation to different pages
                setTimeout(() => {
                    this.closeMobileMenu()
                }, 150)
            }
        } else {
            // Close menu for regular links
            setTimeout(() => {
                this.closeMobileMenu()
            }, 150)
        }
    }

    smoothScrollToSection(hash) {
        const target = document.querySelector(hash)

        if (target) {
            const headerOffset = this.headerHeight + 20
            const elementPosition = target.getBoundingClientRect().top
            const offsetPosition = elementPosition + window.pageYOffset - headerOffset

            window.scrollTo({
                top: offsetPosition,
                behavior: 'smooth'
            })
        }
    }

    centerMobileNavItem(item) {
        const container = this.mobileNavLinksTarget
        const itemRect = item.getBoundingClientRect()
        const containerRect = container.getBoundingClientRect()

        const scrollLeft = item.offsetLeft - (containerRect.width / 2) + (itemRect.width / 2)

        container.scrollTo({
            left: scrollLeft,
            behavior: 'smooth'
        })
    }

    // ============================================
    // Sticky Header on Scroll Up with Enhanced Animation
    // ============================================
    handleScroll() {
        // Throttle scroll events
        if (this.isScrolling) return

        this.isScrolling = true

        requestAnimationFrame(() => {
            const currentScrollTop = window.pageYOffset || document.documentElement.scrollTop

            // Add scrolling class for micro-animations
            this.headerTarget.classList.add("is-scrolling")

            // Clear previous timer
            if (this.scrollTimer) clearTimeout(this.scrollTimer)

            // Remove scrolling class after scroll stops
            this.scrollTimer = setTimeout(() => {
                this.headerTarget.classList.remove("is-scrolling")
            }, 150)

            // Add shadow with smooth transition when scrolled
            if (currentScrollTop > 50) {
                this.headerTarget.classList.add("header-scrolled")
            } else {
                this.headerTarget.classList.remove("header-scrolled")
            }

            // Determine scroll direction with smooth animation
            if (currentScrollTop > this.lastScrollTop && currentScrollTop > this.headerHeight) {
                // Scrolling down
                if (!this.isScrollingDown) {
                    this.isScrollingDown = true
                    this.headerTarget.classList.add("header-hidden")
                    this.headerTarget.classList.remove("header-visible")
                }
            } else if (currentScrollTop < this.lastScrollTop) {
                // Scrolling up
                if (this.isScrollingDown) {
                    this.isScrollingDown = false
                    this.headerTarget.classList.remove("header-hidden")
                    this.headerTarget.classList.add("header-visible")
                }
            }

            this.lastScrollTop = currentScrollTop <= 0 ? 0 : currentScrollTop
            this.isScrolling = false
        })
    }

    // ============================================
    // Mobile Menu Controls
    // ============================================
    toggleMobileMenu(event) {
        event.preventDefault()

        const isActive = this.mobileMenuTarget.classList.contains("active")

        if (isActive) {
            this.closeMobileMenu()
        } else {
            this.openMobileMenu()
        }
    }

    openMobileMenu() {
        // Add opening animation sequence
        this.mobileMenuOverlayTarget.classList.add("active")

        requestAnimationFrame(() => {
            setTimeout(() => {
                this.mobileMenuTarget.classList.add("active")
                this.animateMobileMenuItems()
            }, 50)
        })

        document.body.classList.add("modal-open")

        // Prevent header from hiding when menu is open
        this.headerTarget.classList.remove("header-hidden")
    }

    // Animate mobile menu items with stagger effect
    animateMobileMenuItems() {
        const menuItems = this.mobileMenuTarget.querySelectorAll('.mobile-nav-link')
        menuItems.forEach((item, index) => {
            item.style.opacity = '0'
            item.style.transform = 'translateX(-20px)'

            setTimeout(() => {
                item.style.transition = 'opacity 0.3s ease, transform 0.3s ease'
                item.style.opacity = '1'
                item.style.transform = 'translateX(0)'
            }, index * 50)
        })
    }

    closeMobileMenu(event) {
        if (event) {
            event.preventDefault()
        }

        // Animate out
        this.mobileMenuTarget.classList.add("closing")

        setTimeout(() => {
            this.mobileMenuTarget.classList.remove("active", "closing")
            this.mobileMenuOverlayTarget.classList.remove("active")
            document.body.classList.remove("modal-open")
        }, 300)
    }

    // ============================================
    // Search Modal Controls
    // ============================================
    toggleSearch(event) {
        event.preventDefault()

        const isActive = this.searchModalTarget.classList.contains("active")

        if (isActive) {
            this.closeSearch()
        } else {
            this.openSearch()
        }
    }

    openSearch() {
        // Add opening animation with scale effect
        this.searchOverlayTarget.classList.add("active")

        requestAnimationFrame(() => {
            setTimeout(() => {
                this.searchModalTarget.classList.add("active")
                this.animateSearchContent()
            }, 50)
        })

        document.body.classList.add("modal-open")

        // Prevent header from hiding when search is open
        this.headerTarget.classList.remove("header-hidden")

        // Focus on search input with animation
        setTimeout(() => {
            if (this.hasSearchInputTarget) {
                this.searchInputTarget.focus()
                this.searchInputTarget.parentElement.classList.add("input-focused")
            }
        }, 300)
    }

    // Animate search modal content
    animateSearchContent() {
        const searchContent = this.searchModalTarget.querySelector('.search-modal-content')
        if (searchContent) {
            searchContent.style.opacity = '0'
            searchContent.style.transform = 'translateY(20px)'

            requestAnimationFrame(() => {
                setTimeout(() => {
                    searchContent.style.transition = 'opacity 0.4s ease, transform 0.4s ease'
                    searchContent.style.opacity = '1'
                    searchContent.style.transform = 'translateY(0)'
                }, 100)
            })
        }
    }

    closeSearch(event) {
        if (event) {
            event.preventDefault()
        }

        // Animate out with fade
        this.searchModalTarget.classList.add("closing")

        setTimeout(() => {
            this.searchModalTarget.classList.remove("active", "closing")
            this.searchOverlayTarget.classList.remove("active")
            document.body.classList.remove("modal-open")

            // Reset input focus class
            if (this.hasSearchInputTarget) {
                this.searchInputTarget.parentElement.classList.remove("input-focused")
            }
        }, 300)
    }

    // ============================================
    // Keyboard Controls
    // ============================================
    disconnect() {
        // Clean up when controller is disconnected
        document.body.classList.remove("modal-open")
    }
}
