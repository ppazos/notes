<!DOCTYPE html>
<html>
  <head>
    <meta name="layout" content="notes-internal" />
    <title><g:message code="patient.index.title" /></title>
  </head>
  <body>
    <div class="row">
      <div class="col">

        <!-- Button trigger modal -->
        <span class="float-right">
          <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#create_modal"> + </button>
        </span>

        <!-- Modal -->
        <div class="modal fade" id="create_modal" tabindex="-1" role="dialog" aria-labelledby="create_modal_label" aria-hidden="true">
          <div class="modal-dialog modal-lg" role="document">
            <g:form url="[action:'save']" id="create_form">
              <div class="modal-content">
                <div class="modal-header">
                  <h5 class="modal-title" id="create_modal_label"><g:message code="patient.new.title"/></h5>
                  <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                  </button>
                </div>
                <div class="modal-body">

                  <div class="form-group">
                    <label for="name"><g:message code="patient.attr.firstname"/></label>
                    <input type="text" class="form-control" id="name" name="name" aria-describedby="fileHelp">
                    <!--
                    <small id="fileHelp" class="form-text text-muted">This is some placeholder block-level help text for the above input. It's a bit lighter and easily wraps to a new line.</small>-->
                  </div>
                  <div class="form-group">
                    <label for="lastname"><g:message code="patient.attr.lastname"/></label>
                    <input type="text" class="form-control" id="lastname" name="lastname">
                  </div>
                  <div class="form-group">
                    <label for="dob"><g:message code="patient.attr.dob"/></label>
                    <!--<input type="date" class="form-control" id="dob" name="dob">-->
                    <g:datePicker name="dob" id="dob" class="form-control" precision="day" noSelection="['':'']"/>
                  </div>
                  <div class="form-group">
                    <label for="phone"><g:message code="patient.attr.phone"/></label>
                    <input type="text" class="form-control" id="phone" name="phone">
                  </div>
                  <div class="form-group">
                    <label for="email"><g:message code="patient.attr.email"/></label>
                    <input type="email" class="form-control" id="email" name="email">
                  </div>

                  <div class="form-group">
                    <label><g:message code="patient.attr.sex"/></label>
                    <div class="form-check">
                      <label class="form-check-label">
                        <input type="radio" class="form-check-input" name="sex" id="optionsRadios1" value="M" checked>
                        <g:message code="patient.attr.sex_masculine"/>
                      </label>
                    </div>
                    <div class="form-check">
                    <label class="form-check-label">
                        <input type="radio" class="form-check-input" name="sex" id="optionsRadios2" value="F">
                        <g:message code="patient.attr.sex_feminine"/>
                      </label>
                    </div>
                  </div>
                </div>
                <div class="modal-footer">
                  <button type="button" class="btn btn-secondary" data-dismiss="modal"><g:message code="common.action.close"/></button>
                  <button type="submit" class="btn btn-primary"><g:message code="common.action.save"/></button>
                </div>
              </div>
            </g:form>
          </div>
        </div>

        <h1><g:message code="patient.index.title" /></h1>
      </div>
    </div>

    <g:if test="${flash.message}">
      <div class="row">
        <div class="col">
          <div class="alert alert-custom fade in alert-dismissable show">
           <button type="button" class="close" data-dismiss="alert" aria-label="Close">
              <span aria-hidden="true" style="font-size:20px">&times;</span>
            </button>
            <g:message code="${flash.message}" />
          </div>
        </div>
      </div>
    </g:if>

    <div class="row">
      <div class="col" id="list_container">
        <g:include action="patients_table" />
      </div>
    </div>

    <script>
      $("#create_form").submit(function(e) {

        var url = this.action;

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
            $('#list_container').html(data); // FIXME: this is not a container of the paginator
            $('#create_modal').modal('hide');
          },
          error: function(response, statusText)
          {
            //console.log(JSON.parse(response.responseText));

            // Display validation errors on for fields
            errors = JSON.parse(response.responseText);
            $.each(errors, function( index, error ) {
              console.log(error.defaultMessage, error.field, $('[name='+error.field+']'));
              //$('[name='+error.field+']').parent().addClass('has-danger'); // shows border on form-control
              $('[name='+error.field+']').addClass('is-invalid'); // shows icon if input
            });
          }
        });

        e.preventDefault();
      });

      /*
       * Reset form on modal open
       */
      $('#create_modal').on('show.bs.modal', function (event) {
        $("#create_form")[0].reset();
      });
    </script>
  </body>
</html>
