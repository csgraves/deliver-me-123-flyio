let marker;
let currentRoute;

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
        currentRoute.setMap(null);
        currentRoute.setPanel(null);
        currentRoute = null;
    }
}

function calculateRoute() {
    clearDirections(); //Removes panel after button directions after button press

    const directionsService = new google.maps.DirectionsService();
    const directionsRenderer = new google.maps.DirectionsRenderer({
        draggable: true,
        map,
        panel: document.getElementById("panel"),
    });

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
            display.setDirections(result);
            display.setPanel(document.getElementById("panel")); // Set the panel for the new route
            currentRoute = display;
            currentResult = result;

            route = currentRoute.getDirections();            
            route = route.routes[0];

            const sidebar = document.getElementById("sidebar");
            sidebar.style.display = "block";

            computeTotalDistance(route);
            const [updatedRouteDurationMinutes, updatedRouteDurationWithTrafficMinutes] = routeDurations(route, inMins = true);
            //document.getElementById("totalDuration").innerHTML = updatedRouteDurationMinutes + " mins";
            //document.getElementById("totalDurationTraffic").innerHTML = updatedRouteDurationWithTrafficMinutes + " mins";

            var [duration, durationTraffic] = routeDurations(route);
            var arriveTime = addSecondsToDate(originLeave, duration);
            var arriveTimeTraffic = addSecondsToDate(originLeave, durationTraffic);
            var destLeaveTime = addSecondsToDate(arriveTimeTraffic, 600);
            //document.getElementById("dest_arrive").value = arriveTime;
            var destArriveField = document.getElementById("dest_arrive_field");
            destArriveField.value = setDateTimeFormat(arriveTimeTraffic);
            var destLeaveField = document.getElementById("dest_leave_field");
            destLeaveField.value = setDateTimeFormat(destLeaveTime);

            //Updates only with drag
            display.addListener("directions_changed", () => {
                const updatedDirections = display.getDirections();
                const updatedRoute = updatedDirections.routes[0];

                computeTotalDistance(updatedRoute);
                //const [updatedRouteDurationMinutes, updatedRouteDurationWithTrafficMinutes] = routeDurations(updatedRoute, inMins = true);
                //document.getElementById("totalDuration").innerHTML = updatedRouteDurationMinutes + " mins";
                //document.getElementById("totalDurationTraffic").innerHTML = updatedRouteDurationWithTrafficMinutes + " mins";

                [duration, durationTraffic] = routeDurations(updatedRoute);
                arriveTime = addSecondsToDate(originLeave, duration);
                arriveTimeTraffic = addSecondsToDate(originLeave, durationTraffic);
                destArriveField.value = setDateTimeFormat(arriveTimeTraffic);

                destLeaveTime = addSecondsToDate(arriveTimeTraffic, 600);
                destLeaveField.value = setDateTimeFormat(destLeaveTime);
            });

            // Update route durations when a different route is selected from the panel
            display.addListener("routeindex_changed", () => {
                const selectedRouteIndex = display.getRouteIndex();
                const selectedRoute = currentResult.routes[selectedRouteIndex];

                computeTotalDistance(selectedRoute);
                const [updatedRouteDurationMinutes, updatedRouteDurationWithTrafficMinutes] = routeDurations(selectedRoute, inMins = true);
                //document.getElementById("totalDuration").innerHTML = updatedRouteDurationMinutes + " mins";
                //document.getElementById("totalDurationTraffic").innerHTML = updatedRouteDurationWithTrafficMinutes + " mins";

                var [duration, durationTraffic] = routeDurations(selectedRoute);
                var arriveTime = addSecondsToDate(originLeave, duration);
                var arriveTimeTraffic = addSecondsToDate(originLeave, durationTraffic);
                destArriveField.value = setDateTimeFormat(arriveTimeTraffic);

                destLeaveTime = addSecondsToDate(arriveTimeTraffic, 600);
                destLeaveField.value = setDateTimeFormat(destLeaveTime);
            });
            
        })
        .catch((e) => {
            alert("Could not display directions due to: " + e);
        });
}

function addSecondsToDate(date, seconds) {
    var newDate = new Date(date.getTime() + ((seconds) * 1000));
    return newDate;
}

function routeDurations(updatedRoute, inMins = false) {
    var updatedRouteDuration = updatedRoute.legs.reduce(
        (total, leg) => total + leg.duration.value,
        0
    ) + 30;

    var updatedRouteDurationWithTraffic = updatedRoute.legs.reduce(
        (total, leg) => total + leg.duration_in_traffic.value,
        0
    ) + 30;

    if (inMins == true) {
        updatedRouteDuration = Math.round(
            updatedRouteDuration / 60
        );
        updatedRouteDurationWithTraffic = Math.round(
            updatedRouteDurationWithTraffic / 60
        );

    }

    

    return [updatedRouteDuration, updatedRouteDurationWithTraffic];

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

    //document.getElementById("totalDistance").innerHTML = total + " km";
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

    const calculateRouteButton = document.getElementById("calc-route-button");

    calculateRouteButton.addEventListener('click', function () {
        calculateRoute();
    });

    originLeaveField = document.getElementById("origin_leave_field");
    const now = new Date();
    now.setMinutes(now.getMinutes() + 10);
    originLeaveField.value = setDateTimeFormat(now);

    //Display dest / origin fields if they've values
    if (dest_address.value !== '' && dest_lon.value !== '' && dest_lat.value !== '') {
        // If all fields have values, show the dest-fields div
        destFields.style.display = "block";
    }
    if (origin_address.value !== '' && origin_lon.value !== '' && origin_lat.value !== '') {
        // If all fields have values, show the dest-fields div
        originFields.style.display = "block";
    }

});

function showFieldsIfNotEmpty() {
    // Check if the destination address, longitude, and latitude fields have values
    if ($('#dest_address').val() && $('#dest_lon').val() && $('#dest_lat').val()) {
        // If all fields have values, show the dest-fields div
        $('#dest-fields').show();
    }
}

function setDateTimeFormat(dateTime) {

    const year = dateTime.getFullYear();
    const month = String(dateTime.getMonth() + 1).padStart(2, "0");
    const day = String(dateTime.getDate()).padStart(2, "0");
    const hours = String(dateTime.getHours()).padStart(2, "0");
    const minutes = String(dateTime.getMinutes()).padStart(2, "0");

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