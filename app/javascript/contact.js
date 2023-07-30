document.addEventListener("DOMContentLoaded", function (event) {
    var messageSelect = document.getElementById('message_type');
    var selectedMessageField = document.getElementById('selected-message');


    messageSelect.addEventListener('change', function (event) {
        var selectedMessage = messageSelect.value;
        selectedMessageField.value = selectedMessage;
    });
});