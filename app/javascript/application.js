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

import Popover from 'bootstrap/js/dist/popover';

document.addEventListener("DOMContentLoaded", function (event) {
    // Retrieve the deliveries data from the data attribute
    var scheduleDataElement = document.getElementById("schedule-data");
    var deliveriesData = JSON.parse(scheduleDataElement.dataset.deliveries);

    function convertDeliveriesToEvents(deliveriesData) {
        return deliveriesData.map(delivery => ({
            title: ``,
            start: delivery.origin_leave,
            end: delivery.dest_leave,
            extendedProps: {
                originAddress: delivery.origin_address,
                destAddress: delivery.dest_address,
                deliveryId: delivery.id,
                driver: delivery.driver_email
            }
        }));
    }

    events = convertDeliveriesToEvents(deliveriesData);
    //console.log(events);
    let popover = null;
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
                    //console.log('Event dropped:', info.event);
                    
                },
                eventClick: function (info) {
                    //console.log("Event Clicked");
                    var deliveryId = info.event.extendedProps.deliveryId;
                    window.location.href = '/deliveries/' + deliveryId;
                },
                eventMouseEnter: function (info) {
                    // Create the HTML for the popover
                    let popoverContent = `
                <strong>Origin:</strong> ${info.event.extendedProps.originAddress}<br/>
                <strong>Destination:</strong> ${info.event.extendedProps.destAddress}<br/>
                <strong>Driver:</strong> ${info.event.extendedProps.driver}<br/>
                <br>Click for delivery details</br>
            `;

                    info.el.setAttribute('data-bs-toggle', 'popover');
                    info.el.setAttribute('data-bs-content', popoverContent);
                    info.el.setAttribute('data-bs-html', true);
                    info.el.setAttribute('data-bs-trigger', 'hover');

                    popover = new bootstrap.Popover(info.el, {
                        container: 'body'
                    });
                },
                eventMouseLeave: function (info) {
                    if (popover) {
                        popover.dispose();
                        popover = null;
                    }
                }
            }
        }
    });

    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
});