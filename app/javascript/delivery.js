let map;
let searchBox;
let marker;

function deliveryMap() {
    map = new google.maps.Map(document.getElementById("map"), {
        center: { lat: 51.5072178, lng: -0.1275862 },
        zoom: 15,
        mapTypeId: "roadmap",
    });

    const input = document.getElementById("pac-input");
    searchBox = new google.maps.places.SearchBox(input);

    map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);
    map.addListener("bounds_changed", () => {
        searchBox.setBounds(map.getBounds());
    });

    searchBox.addListener("places_changed", () => {
        const places = searchBox.getPlaces();

        if (places.length == 0) {
            return;
        }

        if (marker) {
            marker.setMap(null); // Remove the existing marker if it exists
        }

        const place = places[0];

        if (!place.geometry || !place.geometry.location) {
            console.log("Returned place contains no geometry");
            return;
        }

        marker = new google.maps.Marker({
            map,
            position: place.geometry.location,
            draggable: true,
        });

        map.setCenter(place.geometry.location);

        document.getElementById("lat").value = place.geometry.location.lat();
        document.getElementById("lon").value = place.geometry.location.lng();
        let address = place.formatted_address;

        if (place.name) {
            address = `${place.name}, ${address}`;
        }

        document.getElementById("address").value = address;

        const infoWindow = new google.maps.InfoWindow({
            content: `<strong>${place.name}</strong><br>${place.formatted_address}`,
        });

        marker.addListener("click", () => {
            infoWindow.open(map, marker);
        });

        marker.addListener("dragend", () => {
            const newPosition = marker.getPosition();
            const geocoder = new google.maps.Geocoder();

            geocoder.geocode({ location: newPosition }, (results, status) => {
                if (status === "OK" && results[0]) {
                    const updatedPlace = results[0];

                    let updatedAddress = updatedPlace.formatted_address;

                    if (updatedPlace.name) {
                        updatedAddress = `${updatedPlace.name}, ${updatedAddress}`;
                    }

                    infoWindow.setContent(updatedAddress);

                    document.getElementById("lat").value = newPosition.lat();
                    document.getElementById("lon").value = newPosition.lng();
                    document.getElementById("address").value = updatedAddress;
                }
            });
        });
    });
}

document.addEventListener("DOMContentLoaded", function (event) {
    // Initialize the map when the DOM is ready
    deliveryMap();

    const setOriginButton = document.getElementById("set-origin-button");
    setOriginButton.addEventListener("click", function () {
        const origin_lat = document.getElementById("lat").value;
        const origin_lon = document.getElementById("lon").value;
        const origin_address = document.getElementById("address").value;

        // Update the hidden fields with the current values
        document.getElementById("origin_lat").value = origin_lat;
        document.getElementById("origin_lon").value = origin_lon;
        document.getElementById("origin_address").value = origin_address;
    });
});