let marker;
let currentRoute = null;

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
            if (checkPlaceNameInAddressComponents(place)) {
                address = `${address}`;
            }
            else {
                address = `${place.name}, ${address}`;

            }

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


    // Route
 
}

function clearDirections() {
    if (currentRoute) {
        currentRoute.setMap(null); // Remove route from the map
        currentRoute.setPanel(null); // Remove route from the panel
        currentRoute = null;
    }
}

function calculateRoute() {
    clearDirections();

    const directionsService = new google.maps.DirectionsService();
    const directionsRenderer = new google.maps.DirectionsRenderer({
        draggable: true,
        map,
        panel: document.getElementById("panel"),
    });

    if (currentRoute) {
        currentRoute.setMap(null);
        currentRoute = null;
    }

    const originLat = Number(document.getElementById("origin_lat").value);
    const originLng = Number(document.getElementById("origin_lon").value);
    const destinationLat = Number(document.getElementById("dest_lat").value);
    const destinationLng = Number(document.getElementById("dest_lon").value);
    const originLeaveString = document.getElementById("origin_leave_field").value;
    const originLeave = new Date(originLeaveString);

    const origin = new google.maps.LatLng(originLat, originLng);
    const destination = new google.maps.LatLng(destinationLat, destinationLng);

    displayRoute(origin, destination, originLeave, directionsService, directionsRenderer);
}

function displayRoute(origin, destination, originLeave, service, display) {
    service
        .route({
            origin: origin,
            destination: destination,
            provideRouteAlternatives: true,
            travelMode: google.maps.TravelMode.DRIVING,
            drivingOptions: {
                departureTime: originLeave,
                trafficModel: 'bestguess'
            },
            avoidTolls: true,
        })
        .then((result) => {
            if (currentRoute) {
                currentRoute.setMap(null); // Remove previous route from the map
                currentRoute.setPanel(null); // Remove previous route from the panel
            }

            display.setDirections(result);
            display.setPanel(document.getElementById("panel")); // Set the panel for the new route
            currentRoute = display;
            currentResult = result;

            route = currentRoute.getDirections();            
            route = route.routes[0];

            computeTotalDistance(route);
            routeDurations(route);

            //Updates only with drag
            display.addListener("directions_changed", () => {
                const updatedDirections = display.getDirections();
                const updatedRoute = updatedDirections.routes[0];

                computeTotalDistance(updatedRoute);
                routeDurations(updatedRoute);
            });

            // Update route durations when a different route is selected from the panel
            display.addListener("routeindex_changed", () => {
                const selectedRouteIndex = display.getRouteIndex();
                const selectedRoute = currentResult.routes[selectedRouteIndex];

                computeTotalDistance(selectedRoute);
                routeDurations(selectedRoute);
            });
            
        })
        .catch((e) => {
            alert("Could not display directions due to: " + e);
        });
}

function routeDurations(updatedRoute) {
    const updatedRouteDuration = updatedRoute.legs.reduce(
        (total, leg) => total + leg.duration.value,
        0
    );

    const updatedRouteDurationWithTraffic = updatedRoute.legs.reduce(
        (total, leg) => total + leg.duration_in_traffic.value,
        0
    );

    const updatedRouteDurationMinutes = Math.round(
        updatedRouteDuration / 60
    );
    const updatedRouteDurationWithTrafficMinutes = Math.round(
        updatedRouteDurationWithTraffic / 60
    );

    document.getElementById("totalDuration").innerHTML = updatedRouteDurationMinutes + " mins";
    document.getElementById("totalDurationTraffic").innerHTML = updatedRouteDurationWithTrafficMinutes + " mins";

}

function computeTotalDistance(route) {
    let total = 0;
    const myroute = route;    

    if (!myroute) {
        return;
    }

    for (let i = 0; i < myroute.legs.length; i++) {
        total += myroute.legs[i].distance.value;
    }

    total = total / 1000;

    document.getElementById("totalDistance").innerHTML = total + " km";
}

document.addEventListener("DOMContentLoaded", function (event) {
    deliveryMap();

    const setOriginButton = document.getElementById("set-origin-button");
    const originFields = document.getElementById("origin-fields");

    const setDestButton = document.getElementById("set-dest-button");
    const destFields = document.getElementById("dest-fields");

    setOriginButton.addEventListener("click", function () {
        const origin_lat = document.getElementById("lat").value;
        const origin_lon = document.getElementById("lon").value;
        const origin_address = document.getElementById("address").value;

        // Update the hidden fields with the current values
        document.getElementById("origin_lat").value = origin_lat;
        document.getElementById("origin_lon").value = origin_lon;
        document.getElementById("origin_address").value = origin_address;

        originFields.style.display = "block";
    });

    setDestButton.addEventListener("click", function () {
        const dest_lat = document.getElementById("lat").value;
        const dest_lon = document.getElementById("lon").value;
        const dest_address = document.getElementById("address").value;

        // Update the hidden fields with the current values
        document.getElementById("dest_lat").value = dest_lat;
        document.getElementById("dest_lon").value = dest_lon;
        document.getElementById("dest_address").value = dest_address;

        destFields.style.display = "block";
    });

    // Switch Dest arrive and origin depart displays
    var toDestArriveButton = document.getElementById('switch-to-dest-arrive-button');
    var originLeaveField = document.getElementById('origin_leave_field');
    var destArriveField = document.getElementById('dest_arrive_field');
    var toOriginLeaveButton = document.getElementById('switch-to-origin-depart-button');

    var originLeaveDivs = document.getElementsByClassName('origin-leave');
    var destarriveDivs = document.getElementsByClassName('dest-arrive');


    toDestArriveButton.addEventListener('click', function () {
        for (var i = 0; i < originLeaveDivs.length; i++) {
            originLeaveDivs[i].style.display = 'none';
        }
        for (var i = 0; i < originLeaveDivs.length; i++) {
            destarriveDivs[i].style.display = 'block';
        }
        originLeaveField.value = ''
    });

    // Add a click event listener to the switch button
    toOriginLeaveButton.addEventListener('click', function () {
        for (var i = 0; i < originLeaveDivs.length; i++) {
            destarriveDivs[i].style.display = 'none';
        }
        for (var i = 0; i < originLeaveDivs.length; i++) {
            originLeaveDivs[i].style.display = 'block';
        }
        destArriveField.value = ''
    });

    const calculateRouteButton = document.getElementById("calc-route-button");

    calculateRouteButton.addEventListener('click', function () {
        calculateRoute();
    });

    originLeaveField = document.getElementById("origin_leave_field");
    originLeaveField.value = setTimePlus10();



});

function setTimePlus10() {
    const now = new Date();
    now.setMinutes(now.getMinutes() + 10);

    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, "0");
    const day = String(now.getDate()).padStart(2, "0");
    const hours = String(now.getHours()).padStart(2, "0");
    const minutes = String(now.getMinutes()).padStart(2, "0");

    const defaultDateTime = `${year}-${month}-${day}T${hours}:${minutes}`;

    return defaultDateTime

}

function checkPlaceNameInAddressComponents(place) {
  const placeName = place.name.toLowerCase();
  
  // Iterate over each address component
  for (let i = 0; i < place.address_components.length; i++) {
    const component = place.address_components[i];
    
    // Check if place name is present in the long_name or short_name of the address component
    if (
      component.long_name.toLowerCase().includes(placeName) ||
      component.short_name.toLowerCase().includes(placeName)
    ) {
      return true;
    }
    
    // Check if place name is present in any of the types of the address component
    for (let j = 0; j < component.types.length; j++) {
      const type = component.types[j];
      
      if (type.toLowerCase().includes(placeName)) {
        return true;
      }
    }
  }
  
  return false;
}

window.initMap = deliveryMap;