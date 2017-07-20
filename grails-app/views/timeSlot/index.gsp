<!DOCTYPE html>
<html>
  <head>
    <meta name="layout" content="notes-internal" />
    <title><g:message code="timeSlot.index.title" /></title>
    <link rel="stylesheet" href="https://fullcalendar.io/js/fullcalendar-3.4.0/fullcalendar.min.css"></link>
    <script type="text/javascript" src="https://fullcalendar.io/js/fullcalendar-3.4.0/lib/moment.min.js"></script>
    <script type="text/javascript" src="https://fullcalendar.io/js/fullcalendar-3.4.0/fullcalendar.min.js">
    </script>
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
        // page is now ready, initialize the calendar...
        $('#calendar').fullCalendar({
            // put your options and callbacks here
        })
    });
    </script>

  </body>
</html>