'use strict';

$(document).ready(function() {

    var pingButton  = $('#ping_button');
    var pingInput   = $('#ping_input');
    var eventList   = $('#message_list');
    var eventSource = new EventSource("http://localhost:8080");

    pingButton.click(function() {
        var message = pingInput.val();
        console.log(message);
        $.post('http://localhost:8080', message)
    });

    eventSource.addEventListener('open', function(e) {
        console.log(e);
    });

    eventSource.addEventListener('message', function(e) {
        console.log(e);

        var li = $('<li>');
        li.text(e.data);

        eventList.append(li);
    });

    eventSource.addEventListener('error', function(e) {
        console.log(e);
    });

});