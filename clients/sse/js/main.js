'use strict';

$(document).ready(function() {

    var eventList   = $('#message_list');
    var eventSource = new EventSource("http://localhost:8080");

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