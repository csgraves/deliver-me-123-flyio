import { Application } from "@hotwired/stimulus"

const application = Application.start()

import controllers from "./**/*_controller.js"
controllers.forEach((controller) => {
    application.register(controller.name, controller.module.default)
})

// Configure Stimulus development experience
application.debug = false
window.Stimulus = application
//window.deliveryMap = deliveryMap



export { application }


/*
window.fireMapsLoadedEvent = function () {
    const evt = new Event("mapsLoaded")
    document.dispatchEvent(evt)
}
*/
