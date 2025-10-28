import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="cart"
export default class extends Controller {
    static targets = ["quantity", "total"]

    updateQuantity(event) {
        const form = event.target.closest('form')
        if (form) {
            form.requestSubmit()
        }
    }

    incrementQuantity(event) {
        const input = event.currentTarget.parentElement.querySelector('input[type="number"]')
        if (input) {
            input.value = parseInt(input.value) + 1
            const form = input.closest('form')
            if (form) {
                form.requestSubmit()
            }
        }
    }

    decrementQuantity(event) {
        const input = event.currentTarget.parentElement.querySelector('input[type="number"]')
        if (input && parseInt(input.value) > 1) {
            input.value = parseInt(input.value) - 1
            const form = input.closest('form')
            if (form) {
                form.requestSubmit()
            }
        }
    }
}
