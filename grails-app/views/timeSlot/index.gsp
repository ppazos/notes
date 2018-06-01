<!DOCTYPE html>
<html>
  <head>
    <meta name="layout" content="notes-internal" />
    <title><g:message code="timeslot.index.title" /></title>
    <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/fullcalendar/3.4.0/fullcalendar.min.css"></link>
    <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/moment.js/2.18.1/moment.min.js"></script>
    <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/fullcalendar/3.4.0/fullcalendar.min.js"></script>

    <asset:javascript src="tempusdominus-bootstrap-4.min.js" />
    <asset:stylesheet src="tempusdominus-bootstrap-4.min.css"/>

    <style>
    #calendar h2 {
      font-size: 22px;
    }
    .fc-widget-header{
      background-color: #8274C1;
      color: #FFF;
    }
    /*#status, */
    #times_container, #patients, #scheduledForContainer {
      display: none; /* display for event edit */
    }
    .timepicker-picker .btn {
      background-color: transparent;
      box-shadow: none;
    }
    .timepicker-picker .btn span, .timepicker-picker button {
      background-color: #9B8FCD !important;
    }
    .timepicker-picker .btn span:hover {
      background-color: #8274C1 !important;
    }
    input[name=times] {
      width: 85px !important;
      text-align: right;
    }
    #repeat > * {
      margin-right: 5px; /* adds space between inline elements for repeat/times */
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
              <input type="hidden" name="id" value="" />
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
                    <input type="text" class="form-control" id="name" name="name" required="true" />
                  </div>
                  <div class="form-group">
                    <label for="start"><g:message code="timeslot.attr.start"/></label>
                    <input type="text" class="form-control datetimepicker-input" id="start" name="start" data-toggle="datetimepicker" data-target="#start" />
                  </div>
                  <div class="form-group">
                    <label for="end"><g:message code="timeslot.attr.end"/></label>
                    <input type="text" class="form-control datetimepicker-input" id="end" name="end" data-toggle="datetimepicker" data-target="#end" />
                  </div>
                  <div class="form-group">
                    <label for="color"><g:message code="timeslot.attr.color"/></label>
                    <input type="color" id="color" name="color" value="#9B8FCD" />
                  </div>
                  <div class="form-inline form-group" id="repeat">
                    <label for="repeat"><g:message code="timeslot.attr.repeat"/></label>
                    <select name="repeat" class="form-control">
                      <option value="once"><g:message code="timeslot.attr.period.once"/></option>
                      <option value="weekly"><g:message code="timeslot.attr.period.weekly"/></option>
                      <option value="monthly"><g:message code="timeslot.attr.period.monthly"/></option>
                    </select>
                    <label for="times" id="times_container">
                      <input type="number" id="times" name="times" value="2" min="2" class="form-control" />
                      <g:message code="timeslot.attr.times"/>
                    </label>
                    <br/>
                    <small class="form-text text-muted"><g:message code="timeslot.attr.repeat.help"/></small>
                  </div>
                  <div class="form-group" id="status">
                    <label><g:message code="timeslot.attr.status"/></label>
                    <div>
                      <label><input type="radio" name="status" value="open" checked="checked" /> <g:message code="timeslot.attr.status_open"/></label>
                      <label><input type="radio" name="status" value="scheduled" /> <g:message code="timeslot.attr.status_scheduled"/></label>
                    </div>
                    <small class="form-text text-muted"><g:message code="timeslot.attr.status.help"/></small>
                  </div>
                  <!-- patient data for already scheduled -->
                  <div class="form-group" id="scheduledForContainer">
                    <input type="hidden" name="pid" /><!-- Set by JS when a slot is selected and is scheduled for someone, needed for update -->
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
                              '<tr><td>'+patient.name+'</td><td>'+patient.lastname+'</td><td>'+patient.dob+'</td><td>'+patient.sex+'</td><td><input type="radio" name="pid_radio" value="'+patient.id+'" required="true"/></td></tr>'
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
          <div class="col">
            <div class="alert alert-custom  fade in alert-dismissable show">
             <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true" style="font-size:20px">&times;</span>
              </button>
              <g:message code="${flash.message}" />
            </div>
          </div>
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

      $('select[name=repeat]').on('change', function(e) {
        console.log(this.value);
        if (this.value != 'once')
        {
          $('#times_container').show();
        }
        else
        {
          $('#times_container').hide();
        }
      });

      // ---------------------------------------------------------
      // avoids problem of "too much recursion" when reloading
      // https://github.com/tempusdominus/bootstrap-4/issues/123
      //
      $('#start').val('');
      $('#end').val('');

      // start/end fields are datetime pickers
      $('#start').datetimepicker({sideBySide: true, icons: {up: 'fa fa-chevron-up', down: 'fa fa-chevron-down'}, useCurrent: false});
      $('#end').datetimepicker(  {sideBySide: true, icons: {up: 'fa fa-chevron-up', down: 'fa fa-chevron-down'}, useCurrent: false});

      // both datetime pikers are linked
      $('#start').on('change.datetimepicker', function(e){
        $('#end').datetimepicker('minDate', e.date);
      });
      $('#end').on('change.datetimepicker', function(e){
        $('#start').datetimepicker('maxDate', e.date);
      });
      // ---------------------------------------------------------

      // update UI status when status value is changed (shows/hides stuff)
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
          //console.log('render', event, element);
          //called when selecting event on calendar and changing its size
          if (event.status == 'scheduled')
          {
            $(element).css('border-width', '3px');
          }
        },
        eventClick: function(evn, jsEvent, view) { // event show

          //console.log('Event: ' + evn.title +' '+ new Date(evn.start));
          //console.log(evn.id, evn.color);
          //console.log(evn, evn.status);
          //alert('Coordinates: ' + jsEvent.pageX + ',' + jsEvent.pageY);
          //alert('View: ' + view.name); // month

          // the repeat fields are only for the create not the show
          $('#repeat').hide();

          // clean search
          $('[name=patientSearch]').val('');

          // hide patiend schedule DOM
          $('#patients').hide();

          // empty previous patient lookup for scheduling
          $('#scheduledForLookupTable > tbody').empty();

          if (evn.scheduledFor)
          {
            patient = evn.scheduledFor;

            $('#scheduledForContainer').show();
            $('input[name=pid]', '#scheduledForContainer').val(patient.id);

            //console.log(patient);

            $('#scheduledForTable > tbody').empty();

            $('#scheduledForTable > tbody').append(
              '<tr><td>'+patient.name+'</td><td>'+patient.lastname+'</td><td>'+new Date(patient.dob).toLocaleDateString()+'</td><td>'+patient.sex+'</td></tr>'
            );
          }
          else
          {
            $('#scheduledForContainer').hide();
          }

          // change the border color just for fun
          //$(this).css('border-color', 'red');
          $('input[name=name]').val(evn.title);
          $('input[name=id]').val(evn.id);
          $('input[name=color]').val(evn.color);

          /*
          console.log(evn.start, evn.start.format());
          console.log($('#start').data('datetimepicker').date());
          console.log(evn.end, evn.end.format());
          console.log($('#end').data('datetimepicker').date());
          */

          //$('input[name=start]').val(evn.start.toISOString()); // UTC date considers local TZ
          //$('input[name=end]').val(evn.end.toISOString());

          //console.$('#end').datetimepicker('minDate')

          //$('#start').val('');
          //$('#end').val('');

          //$('#start').datetimepicker('maxDate', null);
          //$('#end').datetimepicker('minDate', null);

          $('#start').data('datetimepicker').date(evn.start);
          $('#end').data('datetimepicker').date(evn.end);

          $('[name=status][value='+ evn.status +']').prop('checked', true);
          //$('#status').show();

          $('#create_modal').modal('show');
        },
        eventDrop: function(event, delta, revertFunc) { // delta is miliseconds

          //console.log(event.title + " was dropped on " + event.start.format() +" was changed by "+ delta);

          //if (!confirm("Are you sure about this change?")) {
          //  revertFunc();
          //}

          // FIXME: refactor, same as resizeEvent
          $.ajax({
            type: "POST",
            url: '${createLink(action:"update")}',
            data: {id: event.id, start: event.start.toISOString(), end: event.end.toISOString()},
            success: function(data, statusText, response)
            {
              //console.log(data);
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

          //console.log(event.title + " end is now " + event.end.format() +" was changed by "+ delta);

          //if (!confirm("is this okay?")) {
          //  revertFunc();
          //}

          $.ajax({
            type: "POST",
            url: '${createLink(action:"update")}',
            data: {id: event.id, start: event.start.toISOString(), end: event.end.toISOString()},
            success: function(data, statusText, response)
            {
              //console.log(data);
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
        select: function( start, end, jsEvent, view, resource ) { // calendar select, create new event

          //console.log(start, end, jsEvent, view, resource);

//console.log( $('#start') );
//console.log( $('#start').data('datetimepicker').options() );

          //console.log($('#calendar').fullCalendar('getView'));

          // On month view, show the time pickers because start and end dont have time
          /*
          if ($('#calendar').fullCalendar('getView').type == 'month')
          {
            console.log('view month');
            //end.set({hour: 0, minute: 0, second: 0, millisecond: 0});
          }
          */

          /*
          console.log(start, start.format(), start.toDate());
          console.log($('#start').data('datetimepicker').date());
          console.log(end, end.format(), end.toDate());
          console.log($('#end').data('datetimepicker').date());
          */
          //console.log(start.format("YYYY-MM-DDThh:mm"));
          //console.log(start.format('YYYY-MM-DDTHH:mm:ssZ'));

          //console.log(start.format("YYYY-MM-DD[T]hh:mm"));
          //console.log(start.toDate().format("YYYY-MM-DDThh:mm"));


          //$('input[name=start]').val(start.toISOString()); // UTC date considers local TZ
          //$('input[name=end]').val(end.toISOString());

          //$('#start').val('');
          //$('#end').val('');

          // the repeat fields are only for the create, the show might hide them
          $('#repeat').show();
          $('#start').data('datetimepicker').date(start);
          $('#end').data('datetimepicker').date(end);

          //console.log('calendar click', $('#start').data('datetimepicker').date(), $('#end').data('datetimepicker').date());

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

    /*
     * hides and reoves stuff from the event create modal to show the modal again on it's original state.
     */
    var reset_modal = function()
    {
      // by default the event uid field should be empty
      $('input[name=id]').val('');

      $('#scheduledForLookupTable > tbody').empty(); // remove contents of previous search
      $('#scheduledForTable > tbody').empty(); // remove contents of previous scheduled for patient

      $('input[name=pid]', '#scheduledForContainer').val(''); // remove pid if previously selected for a scheduled slot
      $('#scheduledForContainer').hide(); // // by default hide patient table

      $('#patients').hide();

      // by default repeat times should be hidden
      $('#times_container').hide();

      // by default the radio selected for the status is the "open"
      $("input[name=status][value='open']").prop("checked",true);


      $("#create_form")[0].reset();

      // this also updates the minDate/maxDate constraints
      $('#start').data('datetimepicker').date(null);
      $('#end').data('datetimepicker').date(null);

      $('#calendar').fullCalendar('unselect');
      //$('#status').hide();
    };
    </script>

    <script>
      $("#create_form").submit(function(e) {

        var url = this.action;

        if ($('input[name=id]').val() != "")
        {
          url = url.replace('save', 'update'); // reuses the save form for update
        }

        //console.log(url, $("#create_form").serialize());

        // Reset validation
        $('input').parent().removeClass('has-danger');
        $('input').removeClass('form-control-danger');

        selected_pid = $('input[name=pid_radio]:checked').val();
        if (selected_pid)
        {
          $('input[name=pid]').val(selected_pid);
        }

        // format dates in the servers format
        var data = $("#create_form").serializeArray();
        data.find( function(el){ if (el.name == 'start') return el; } ).value = $('#start').data('datetimepicker').date().toISOString();
        data.find( function(el){ if (el.name == 'end')   return el; } ).value = $('#end').data('datetimepicker').date().toISOString();

        // patientSearch is not needed for the save/update, here we remove it from the params
        remove_index = data.findIndex( function(el){ if (el.name == 'patientSearch')   return el; } );
        if (remove_index > -1) data.splice(remove_index, 1);

        remove_indexx = data.findIndex( function(el){ if (el.name == 'pid_radio')   return el; } );
        if (remove_index > -1) data.splice(remove_index, 1);

        console.log(data, $.param(data), $('#start').data('datetimepicker').date().toISOString());

        $.ajax({
          type: "POST",
          url: url,
          data: $.param(data),
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
       * This is called when: close btn click, X click, save btn click (after submit response is received)
       */
      $('#create_modal').on('hide.bs.modal', function (event) {
        reset_modal();
      });
    </script>

  </body>
</html>
