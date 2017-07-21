<!DOCTYPE html>
<html>
  <head>
    <meta name="layout" content="notes-internal" />
    <title><g:message code="timeSlot.index.title" /></title>
    <link rel="stylesheet" href="https://fullcalendar.io/js/fullcalendar-3.4.0/fullcalendar.min.css"></link>
    <script type="text/javascript" src="https://fullcalendar.io/js/fullcalendar-3.4.0/lib/moment.min.js"></script>
    <script type="text/javascript" src="https://fullcalendar.io/js/fullcalendar-3.4.0/fullcalendar.min.js"></script>
    <style>
    #calendar h2 {
      font-size: 22px;
    }
    .fc-widget-header{
      background-color: #8274C1;
      color: #FFF;
    }
    </style>
  </head>
  <body>
    <div class="row">
      <div class="col">
        <span class="float-right">
          <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#myModal">
          + Slot
          </button>
        </span>

        <h1><g:message code="timeSlot.index.title" /></h1>
      </div>
    </div>

    <g:if test="${flash.message}">
      <div class="row">
        <div class="col">
          <div class="message" role="status">${flash.message}</div>
        </div>
      </div>
    </g:if>

    <div class="row">
      <div class="col">
        <div id='calendar'></div>
      </div>
      <%--
      <div class="col" id="table">
        <f:table collection="${timeSlotList}" />
        <div class="pagination">
          <g:paginate total="${timeSlotCount ?: 0}" />
        </div>
      </div>
      --%>
    </div>
    <script type="text/javascript">
    $(document).ready(function() {
      
      $('#calendar').fullCalendar({
        header: {
          left:   'title',
          center: 'month agendaWeek',
          right:  'today prev,next'
        },
        dayClick: function() {
          alert('a day has been clicked!');
        },
        showNonCurrentDates: false,
        height: 700,
        firstDay: 1,
        displayEventTime: true,
        displayEventEnd: true,
        eventTextColor: "#FFFFFF",
        eventColor: "#9B8FCD",
        editable: true,
        //startEditable: true,
        //durationEditable: true,
        selectable: true,
        selectHelper: true, // draws event while selecting
        timezone: 'local',
        longPressDelay: 300, // for touch events
        events: [
          {
            id: 1, // TODO: UID
            title: "hola",
            start: "2017-07-21T10:00-03:00", // NO TZ is GMT
            end:   "2017-07-21T14:30-03:00"
          },
          {
            id: 2,
            title: "hola",
            start: "2017-07-21T15:00-03:00", // NO TZ is GMT
            end:   "2017-07-21T15:30-03:00"
          }
        ],
        eventClick: function(evn, jsEvent, view) {

          console.log('Event: ' + evn.title +' '+ new Date(evn.start));
          console.log(evn.id)
          //alert('Coordinates: ' + jsEvent.pageX + ',' + jsEvent.pageY);
          //alert('View: ' + view.name); // month

          // change the border color just for fun
          //$(this).css('border-color', 'red');
        },
        eventDrop: function(event, delta, revertFunc) { // delta is miliseconds

          console.log(event.title + " was dropped on " + event.start.format() +" was changed by "+ delta);

          //if (!confirm("Are you sure about this change?")) {
          //  revertFunc();
          //}
        },
        eventResize: function(event, delta, revertFunc) {

          console.log(event.title + " end is now " + event.end.format() +" was changed by "+ delta);

          //if (!confirm("is this okay?")) {
          //  revertFunc();
          //}
        },
        select: function( start, end, jsEvent, view, resource ) {
          console.log(start, end, jsEvent, view, resource);
          if (confirm('Create event?'))
          {
            $('#calendar').fullCalendar('renderEvent', 
            {
              title : 'my pickup slot',
              start : start.toDate(),
              end   : end.toDate(),
            }, true);
          }
          else
          {
            $('#calendar').fullCalendar('unselect');
          }
        }
      })
    });
    </script>

  </body>
</html>