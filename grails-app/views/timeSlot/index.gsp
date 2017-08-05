<!DOCTYPE html>
<html>
  <head>
    <meta name="layout" content="notes-internal" />
    <title><g:message code="timeslot.index.title" /></title>
    <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/fullcalendar/3.4.0/fullcalendar.min.css"></link>
    <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/moment.js/2.18.1/moment.min.js"></script>
    <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/fullcalendar/3.4.0/fullcalendar.min.js"></script>
    <style>
    #calendar h2 {
      font-size: 22px;
    }
    .fc-widget-header{
      background-color: #8274C1;
      color: #FFF;
    }
    #status, #patients, #scheduledForContainer {
      display: none; /* display for event edit */
    }
    </style>
  </head>
  <body>
    <div class="row">
      <div class="col">
        <span class="float-right">
          <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#create_modal"> + </button>
        </span>

        <!-- Modal -->
        <div class="modal fade" id="create_modal" tabindex="-1" role="dialog" aria-labelledby="create_modal_label" aria-hidden="true">
          <div class="modal-dialog modal-lg" role="document">
            <g:form url="[action:'save']" id="create_form">
              <input type="hidden" name="uid" value="" />
              <div class="modal-content">
                <div class="modal-header">
                  <h5 class="modal-title" id="create_modal_label"><g:message code="timeslot.new.title"/></h5>
                  <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                  </button>
                </div>
                <div class="modal-body">
                  
                  <div class="form-group">
                    <label for="name"><g:message code="timeslot.attr.name"/></label>
                    <input type="text" class="form-control" id="name" name="name" />
                  </div>
                  <div class="form-group">
                    <label for="start"><g:message code="timeslot.attr.start"/></label>
                    <input type="text" class="form-control" id="start" name="start" readonly="true" />
                  </div>
                  <div class="form-group">
                    <label for="end"><g:message code="timeslot.attr.end"/></label>
                    <input type="text" class="form-control" id="end" name="end" readonly="true" />
                  </div>
                  <div class="form-group">
                    <label for="color"><g:message code="timeslot.attr.color"/></label>
                    <input type="color" id="color" name="color" value="#9B8FCD" />
                  </div>
                  <div class="form-group" id="status">
                    <label><g:message code="timeslot.attr.status"/></label>
                    <div>
                    <label><input type="radio" name="status" value="open" /> <g:message code="timeslot.attr.status_open"/></label>
                    <label><input type="radio" name="status" value="scheduled" /> <g:message code="timeslot.attr.status_scheduled"/></label>
                    </div>
                  </div>
                  <!-- patient data for already scheduled -->
                  <div class="form-group" id="scheduledForContainer">
                    <table id="scheduledForTable" class="table">
                      <thead>
                      <tr>
                        <th><g:message code="patient.attr.firstname"/></th>
                        <th><g:message code="patient.attr.lastname"/></th>
                        <th><g:message code="patient.attr.dob"/></th>
                        <th><g:message code="patient.attr.sex"/></th>
                      </tr>
                      </thead>
                      <tbody></tbody>
                    </table>
                  </div>
                  <!-- lookup for schedule -->
                  <div class="form-group" id="patients">
                    <label id="lookup"><g:message code="timeslot.schedule_for.label"/> <input name="patientSearch" /></label>
                    <table id="scheduledForLookupTable" class="table">
                      <thead>
                      <tr>
                        <th><g:message code="patient.attr.firstname"/></th>
                        <th><g:message code="patient.attr.lastname"/></th>
                        <th><g:message code="patient.attr.dob"/></th>
                        <th><g:message code="patient.attr.sex"/></th>
                        <th><g:message code="timeslot.patient_select.label"/></th>
                      </tr>
                      </thead>
                      <tbody></tbody>
                    </table>
                  </div>
                  <script type="text/javascript">
                    // ajax patient lookup launched when the user stops writing for 500ms.
                    var timer;
                    $('[name=patientSearch]').on('keyup', function(){
                      
                      clearTimeout(timer);
                      
                      if (this.value)
                      {
                        timer = setTimeout(lookup.bind(null, this.value), 400);
                      }
                    });
                    var lookup = function(q) {
                      
                      $.ajax({
                        type: "GET",
                        url: '${createLink(controller:"patient", action:"lookup")}',
                        data: {q: q},
                        success: function(data, statusText, response)
                        {
                          // empty previous patient lookup for scheduling
                          $('#scheduledForLookupTable > tbody').empty();

                          //console.log(data);
                          $.each(data, function( index, patient ) {
                            console.log(patient);
                            $('#scheduledForLookupTable > tbody').append(
                              '<tr><td>'+patient.name+'</td><td>'+patient.lastname+'</td><td>'+patient.dob+'</td><td>'+patient.sex+'</td><td><input type="radio" name="scheduledForUid" value="'+patient.uid+'" required="true"/></td></tr>'
                            );
                          });
                        },
                        error: function(response, statusText)
                        {
                          console.log(JSON.parse(response.responseText));
                        }
                      });
                    };
                  </script>
                </div>
                <div class="modal-footer">
                  <button type="button" class="btn btn-secondary" data-dismiss="modal"><g:message code="common.action.close"/></button>
                  <button type="submit" class="btn btn-primary"><g:message code="common.action.save"/></button>
                </div>
              </div>
            </g:form>
          </div>
        </div>

        <h1><g:message code="timeslot.index.title" /></h1>
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
    </div>
    <script type="text/javascript">
    $(document).ready(function() {

      $('[value=scheduled]').on('click', function(){

        $('#patients').show();
      });
      $('[value=open]').on('click', function(){

        $('#patients').hide();

        // empty previous patient lookup for scheduling
        $('#scheduledForLookupTable > tbody').empty();

        // if event currently is scheduled let the user know it will lose the schedule if saved
        if ($('#scheduledForTable > tbody').children().length > 0)
        {
          if (confirm('${message(code:"timeslot.confirm_unschedule.label")}'))
          {
            $('#scheduledForTable > tbody').empty();
          }
          else
          {
            return false;
          }
        }
        
      });
      
      $('#calendar').fullCalendar({
        header: {
          left:   'title',
          center: 'agendaWeek', //month // month needs work on the create modal to set whole day or time from user, need datetimepicker for that
          right:  'today prev,next'
        },
        dayClick: function() {
          //alert('a day has been clicked!');
        },
        defaultView: 'agendaWeek',
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
        events: '${createLink(action:"timeslot_list")}',
        eventRender: function( event, element, view ) { // fat border if event is scheduled
          console.log('render', event, element);
          if (event.status == 'scheduled')
          {
            $(element).css('border-width', '3px');
          }
        },
        /*
        loading: function (isLoading) {
          if (!isLoading) {
            console.log();

            events = $('#calendar').fullCalendar('clientEvents');
            $.each(events, function( index, event ) {
              if (event.status == 'scheduled')
              {

              }
            });
          }
        },
        */
        /*
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
        */
        eventClick: function(evn, jsEvent, view) {

          //console.log('Event: ' + evn.title +' '+ new Date(evn.start));
          //console.log(evn.id, evn.color);
          console.log(evn, evn.status);
          //alert('Coordinates: ' + jsEvent.pageX + ',' + jsEvent.pageY);
          //alert('View: ' + view.name); // month

          // clean search
          $('[name=patientSearch]').val('');

          // hide patiend schedule DOM
          $('#patients').hide();

          // empty previous patient lookup for scheduling
          $('#scheduledForLookupTable > tbody').empty();

          if (evn.scheduledFor)
          {
            $('#scheduledForContainer').show();

            patient = evn.scheduledFor;

            $('#scheduledForTable > tbody').empty();

            $('#scheduledForTable > tbody').append(
              '<tr><td>'+patient.name+'</td><td>'+patient.lastname+'</td><td>'+patient.dob+'</td><td>'+patient.sex+'</td></tr>'
            );
          }
          else
          {
            $('#scheduledForContainer').hide();
          }

          // change the border color just for fun
          //$(this).css('border-color', 'red');
          $('input[name=name]').val(evn.title);
          $('input[name=uid]').val(evn.id);
          $('input[name=color]').val(evn.color);
          $('input[name=start]').val(evn.start.toISOString()); // UTC date considers local TZ
          $('input[name=end]').val(evn.end.toISOString());

          $('[name=status][value='+ evn.status +']').prop('checked', true);
          $('#status').show();

          $('#create_modal').modal('show');
        },
        eventDrop: function(event, delta, revertFunc) { // delta is miliseconds

          console.log(event.title + " was dropped on " + event.start.format() +" was changed by "+ delta);

          //if (!confirm("Are you sure about this change?")) {
          //  revertFunc();
          //}

          // FIXME: refactor, same as resizeEvent
          $.ajax({
            type: "POST",
            url: '${createLink(action:"update")}',
            data: {uid: event.id, start: event.start.toISOString(), end: event.end.toISOString()},
            success: function(data, statusText, response)
            {
              console.log(data);
              $('#create_modal').modal('hide');

              $('#calendar').fullCalendar('refetchEvents');
            },
            error: function(response, statusText)
            {
              //console.log(JSON.parse(response.responseText));
              
              // Display validation errors on for fields
              errors = JSON.parse(response.responseText);
              $.each(errors, function( index, error ) {
                console.log(error);
              });
            }
          });
        },
        eventResize: function(event, delta, revertFunc) {

          console.log(event.title + " end is now " + event.end.format() +" was changed by "+ delta);

          //if (!confirm("is this okay?")) {
          //  revertFunc();
          //}

          $.ajax({
            type: "POST",
            url: '${createLink(action:"update")}',
            data: {uid: event.id, start: event.start.toISOString(), end: event.end.toISOString()},
            success: function(data, statusText, response)
            {
              console.log(data);
              $('#create_modal').modal('hide');

              $('#calendar').fullCalendar('refetchEvents');
            },
            error: function(response, statusText)
            {
              //console.log(JSON.parse(response.responseText));
              
              // Display validation errors on for fields
              errors = JSON.parse(response.responseText);
              $.each(errors, function( index, error ) {
                console.log(error);
              });
            }
          });
        },
        select: function( start, end, jsEvent, view, resource ) {

          console.log(start, end, jsEvent, view, resource);
          //console.log($('#calendar').fullCalendar('getView'));

          // On month view, show the time pickers because start and end dont have time
          if ($('#calendar').fullCalendar('getView').type == 'month')
          {
            console.log('view month');
            //end.set({hour: 0, minute: 0, second: 0, millisecond: 0});
          }

          console.log(start.format(), start.toDate());
          console.log(end.format(), end.toDate());
          //console.log(start.format("YYYY-MM-DDThh:mm"));
          //console.log(start.format('YYYY-MM-DDTHH:mm:ssZ'));

          console.log(start.format("YYYY-MM-DD[T]hh:mm"));

          //console.log(start.toDate().format("YYYY-MM-DDThh:mm"));

          $('input[name=start]').val(start.toISOString()); // UTC date considers local TZ
          $('input[name=end]').val(end.toISOString());

          //$('input[name=start]').val('2017-07-21T10:00'); // This works but moment is not retrieving the right format
          //$('input[name=start]').val(start.format('YYYY-MM-DD[T]hh:mm')); // format needed by HTML5 datetime-local
          //$('input[name=end]').val(end.format('YYYY-MM-DD[T]hh:mm'));
          $('#create_modal').modal('show');

/*
            // TODO: render on server response
            $('#calendar').fullCalendar('renderEvent', 
            {
              title : 'my pickup slot',
              start : start.toDate(),
              end   : end.toDate(),
            }, true);
*/
        }
      })
    });
    </script>

    <script>
      $("#create_form").submit(function(e) {

        var url = this.action;

        if ($('input[name=uid]').val() != "")
        {
          url = url.replace('save', 'update'); // reuses the save form for update
        }

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
            console.log(data);
            $('#create_modal').modal('hide');

            $('#calendar').fullCalendar('refetchEvents');
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
       * Reset form on modal close.
       */
      $('#create_modal').on('hide.bs.modal', function (event) {

        $("#create_form")[0].reset();
        $('#calendar').fullCalendar('unselect');
        $('#status').hide();
      });
    </script>

  </body>
</html>
