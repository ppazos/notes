<!DOCTYPE html>
<html>
  <head>
    <meta name="layout" content="notes-internal" />
    <title><g:message code="notecategory.index.title" /></title>
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
                  <h5 class="modal-title" id="create_modal_label"><g:message code="notecategory.new.title"/></h5>
                  <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                  </button>
                </div>
                <div class="modal-body">
                  <div class="form-group">
                    <label for="name"><g:message code="notecategory.attr.name"/></label>
                    <input type="text" class="form-control" id="name" name="name" />
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

        <h1><g:message code="notecategory.index.title" /></h1>
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
        <div id="list_container">
          <g:include action="category_list" />
        </div>
      </div>
    </div>

    <script>
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
            // Update list
            $('#list_container').html(data);
            $('#create_modal').modal('hide');
          },
          error: function(response, statusText)
          {
            //console.log(JSON.parse(response.responseText));

            // Display validation errors on for fields
            errors = JSON.parse(response.responseText);
            $.each(errors, function( index, error ) {
              console.log(error.defaultMessage);
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
      $('#create_modal').on('shown.bs.modal', function (event) {

        // focus on the first input of the form, checking it is enabled and visible
        $('#create_form .modal-body :input:enabled:first').filter(function(){ return $(this).css('display') != 'none';})[0].focus();
      });
    </script>
  </body>
</html>
