import BaseSliderController from "./base_slider_controller"

// Connects to data-controller="hero-slider"
// Homepage hero slider extending base functionality
export default class extends BaseSliderController {
    static values = {
        ...BaseSliderController.values,
        interval: { type: Number, default: 5000 },
        transition: { type: String, default: "fade" }
    }

    connect() {
        super.connect()
    }

    disconnect() {
        super.disconnect()
    }
}
