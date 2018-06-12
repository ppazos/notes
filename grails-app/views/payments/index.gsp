<!DOCTYPE html>
<html>
  <head>
    <meta name="layout" content="notes-internal" />
    <title><g:message code="payments.index.title" /></title>
    <style type="text/css">
      .card.unpaid {
        cursor: pointer;
      }
    </style>
  </head>
  <body>
    <div class="row">
      <div class="col">
        <h1><g:message code="payments.index.title" /></h1>
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
        <g:message code="payments.index.help" />
      </div>
    </div>

    <div class="row">
      <div class="col" id="list_container">
        <g:include action="index_body_partial" />
      </div>
    </div>


    <!-- Modal opened in the context of a slot -->
    <div class="modal fade" id="slot_modal" tabindex="-1" role="dialog" aria-labelledby="create_modal_label" aria-hidden="true">
      <div class="modal-dialog modal-lg" role="document">
        <g:form url="[action:'save']" id="create_form">

          <!-- timeslot id set via JS -->
          <input type="hidden" name="id" />

          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title" id="create_modal_label"><g:message code="payment.create.title"/></h5>
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
            <div class="modal-body">

              <div class="form-group">
                <label for="amount"><g:message code="payment.attr.amount"/></label>
                <input type="number" class="form-control" id="amount" name="amount" aria-describedby="fileHelp">
                <!--
                <small id="fileHelp" class="form-text text-muted">This is some placeholder block-level help text for the above input. It's a bit lighter and easily wraps to a new line.</small>-->
              </div>
              <div class="form-group">
                <label for="paidOn"><g:message code="payment.attr.paidOn"/></label>
                <g:datePicker name="paidOn" id="paidOn" class="form-control" precision="day" noSelection="['':'']"/>
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

    <script>
    // open modal on unpaid slot click
    $('.card.unpaid').on('click', function(e){

      id_field = $('input[name=id]', '#slot_modal');
      id_field.val($(this).data('id'));

      $('#slot_modal').modal({show: true});
    });

    $("#create_form").submit(function(e) {

      var url = this.action;

      // Reset validation
      $('input').removeClass('is-invalid');

      $.ajax({
        type: "POST",
        url: url,
        data: $("#create_form").serialize(),
        success: function(data, statusText, response)
        {
          // Update patient table with new patient
          $('#list_container').html(data); // FIXME: this is not a container of the paginator
          $('#slot_modal').modal('hide');
        },
        error: function(response, statusText)
        {
          //console.log(JSON.parse(response.responseText));

          // Display validation errors on for fields
          errors = JSON.parse(response.responseText);
          $.each(errors, function( index, error ) {
            console.log(error.defaultMessage, error.field, $('[name='+error.field+']'));
            $('[name='+error.field+']').addClass('is-invalid'); // shows icon if input
          });
        }
      });

      e.preventDefault();
    });
    </script>

  </body>
</html>
