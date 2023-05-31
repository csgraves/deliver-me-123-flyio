import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus = application
window.initMap = initMap
//window.deliveryMap = deliveryMap



export { application }


/*
window.fireMapsLoadedEvent = function () {
    const evt = new Event("mapsLoaded")
    document.dispatchEvent(evt)
}
*/

let map; 

function initMap() {
    /*map = new google.maps.Map(document.getElementById("map"), {
        center: { lat: -34.397, lng: 150.644 },
        zoom: 8,
    });*/
}
