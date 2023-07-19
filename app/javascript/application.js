// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
//import "@hotwired/turbo-rails"
//import "./controllers"
import * as bootstrap from "bootstrap"

// Import calendar and its dependencies
import Calendar from '@event-calendar/core';
import TimeGrid from '@event-calendar/time-grid';
import DayGrid from '@event-calendar/day-grid';
import Interaction from '@event-calendar/interaction';

import '@event-calendar/core/index.css';

document.addEventListener("DOMContentLoaded", function (event) {
    // Retrieve the deliveries data from the data attribute
    var scheduleDataElement = document.getElementById("schedule-data");
    var deliveriesData = JSON.parse(scheduleDataElement.dataset.deliveries);

    function convertDeliveriesToEvents(deliveriesData) {
        return deliveriesData.map(delivery => ({
            title: `Destination: ${delivery.dest_address}`,
            start: delivery.origin_leave,
            end: delivery.dest_leave,
            extendedProps: {
                originAddress: delivery.origin_address,
                destAddress: delivery.dest_address
            }
        }));
    }

    events = convertDeliveriesToEvents(deliveriesData);
    //console.log(events);

    let ec = new Calendar({
        target: document.getElementById('ec'),
        props: {
            plugins: [TimeGrid, DayGrid, Interaction],
            options: {
                view: 'timeGridWeek',
                events: events,
                height: '700px',
                nowIndicator: true,
                scrollTime: '06:00:00',
                eventStartEditable: false,
                eventDurationEditable: false,
                headerToolbar: {
                    start: 'title',
                    center: '',
                    end: 'today prev,next dayGridMonth,timeGridWeek,timeGridDay'
                },
                eventDrop: function (info) {
                    console.log('Event dropped:', info.event);
                    // Update your deliveriesArray or perform other actions based on the new event data
                }

            }
        }
    });

    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
});