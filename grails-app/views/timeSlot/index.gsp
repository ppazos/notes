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
          <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#create_modal">
          + Slot
          </button>
        </span>

        <!-- Modal -->
        <div class="modal fade" id="create_modal" tabindex="-1" role="dialog" aria-labelledby="create_modal_label" aria-hidden="true">
          <div class="modal-dialog modal-lg" role="document">
            <g:form url="[action:'save']" id="create_form">
              <div class="modal-content">
                <div class="modal-header">
                  <h5 class="modal-title" id="create_modal_label">New event</h5>
                  <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                  </button>
                </div>
                <div class="modal-body">
                  
                  <div class="form-group">
                    <label for="name">Name</label>
                    <input type="text" class="form-control" id="name" name="name" />
                  </div>
                  <div class="form-group">
                    <label for="start">Start</label>
                    <input type="text" class="form-control" id="start" name="start" readonly="true">
                  </div>
                  <div class="form-group">
                    <label for="end">End</label>
                    <input type="text" class="form-control" id="end" name="end" readonly="true">
                  </div>
                  <div class="form-group">
                    <label for="color">Color</label>
                    <input type="color" class="form-control" id="color" name="color">
                  </div>
                </div>
                <div class="modal-footer">
                  <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                  <button type="submit" class="btn btn-primary">Save changes</button>
                </div>
              </div>
            </g:form>
          </div>
        </div>

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
            console.log(start.toISOString(), end.toISOString());

            $('input[name=start]').val(start.toISOString()); // UTC date considers local TZ
            $('input[name=end]').val(end.toISOString());
            $('#create_modal').modal('show');

            // TODO: render on server response
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

    <script>
      $("#create_form").submit(function(e) {

        var url = this.action;
        console.log(url, $("#create_form").serialize());

        // Reset validation
        $('input').parent().removeClass('has-danger');
        $('input').removeClass('form-control-danger');

        $.ajax({
          type: "POST",
          url: url,
          data: $("#create_form").serialize(),
          success: function(data, statusText, response)
          {
            // Update patient table with new patient
            //$('#table').html(data);
            console.log(data);
            $('#create_modal').modal('hide');
          },
          error: function(response, statusText)
          {
            //console.log(JSON.parse(response.responseText));
            
            // Display validation errors on for fields
            errors = JSON.parse(response.responseText);
            $.each(errors, function( index, error ) {
              $('input[name='+error.field+']').parent().addClass('has-danger');
              $('input[name='+error.field+']').addClass('form-control-danger');
            });
          }
        });

        e.preventDefault();
      });

      /*
       * Reset form on modal open // commented for now to let the script assign the start/end dates into fields
       */
      //$('#create_modal').on('show.bs.modal', function (event) {
      //  $("#create_form")[0].reset();
      //});
    </script>

  </body>
</html>
