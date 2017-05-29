<!DOCTYPE html>
<html>
  <head>
    <meta name="layout" content="main" />
    <g:set var="entityName" value="${message(code: 'patient.label', default: 'Patient')}" />
    <title><g:message code="default.list.label" args="[entityName]" /></title>
  </head>
  <body>
    <div class="row">
      <div class="col">
        <div class="nav" role="navigation">
          <ul>
            <li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
            <li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
          </ul>
        </div>
      </div>
    </div>

    <div class="row">
      <div class="col">

        <!-- Button trigger modal -->
        <span class="float-right">
          <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#myModal">
          + Patient
          </button>
        </span>

        <!-- Modal -->
        <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
          <div class="modal-dialog modal-lg" role="document">
            <g:form url="[action:'save']" id="create_form">
              <div class="modal-content">
                <div class="modal-header">
                  <h5 class="modal-title" id="exampleModalLabel">New patient</h5>
                  <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                  </button>
                </div>
                <div class="modal-body">
                  
                  <div class="form-group">
                    <label for="name">Name</label>
                    <input type="text" class="form-control-file" id="name" name="name" aria-describedby="fileHelp">
                    <small id="fileHelp" class="form-text text-muted">This is some placeholder block-level help text for the above input. It's a bit lighter and easily wraps to a new line.</small>
                  </div>
                  <div class="form-group">
                    <label for="lastname">Lastname</label>
                    <input type="text" class="form-control-file" id="lastname" name="lastname">
                  </div>
                  <div class="form-group">
                    <label for="dob">Dob</label>
                    <input type="date" class="form-control-file" id="dob" name="dob">
                  </div>
                  <div class="form-group">
                    <label for="phone">Phone</label>
                    <input type="text" class="form-control-file" id="phone" name="phone">
                  </div>
                  <div class="form-group">
                    <label for="phone">Email</label>
                    <input type="email" class="form-control-file" id="email" name="email">
                  </div>
                  
                  <div class="form-group">
                    <label>Sex</label>
                    <div class="form-check">
                      <label class="form-check-label">
                        <input type="radio" class="form-check-input" name="sex" id="optionsRadios1" value="M" checked>
                        M
                      </label>
                    </div>
                    <div class="form-check">
                    <label class="form-check-label">
                        <input type="radio" class="form-check-input" name="sex" id="optionsRadios2" value="F">
                        F
                      </label>
                    </div>
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

        <h1><g:message code="default.list.label" args="[entityName]" /></h1>
        <g:if test="${flash.message}">
          <div class="message" role="status">${flash.message}</div>
        </g:if>
      </div>
    </div>

    <div class="row">
      <div class="col" id="table">
      <%--
        <g:render template="patients_table" bean="${patientList}" />
--%>
        <g:include action="patients_table" />

      </div>
    </div>

    <div class="row">
      <div class="col">
        <div class="pagination">
          <g:paginate total="${patientCount ?: 0}" />
        </div>
      </div>
    </div>

    <script>
/*
    var success = function(json, a, b) {
      if (json.status == 'error')
      {
        console.log(json, a, b);
      }
      else
      {
        console.log(json, a, b);
      }
    };
*/

        $("#create_form").submit(function(e) {

          console.log(this.action);
          console.log($("#create_form").serialize());


          var url = this.action;

          $.ajax({
            type: "POST",
            url: url,
            data: $("#create_form").serialize(),
            success: function(data, statusText, response)
            {
              // response.responseJSON == data
              console.log(data);
              console.log(response);
// TODO: process errors
              $('#table').html(data);

              $('#myModal').modal('hide');
            },
            error: function(response, statusText)
            {
                console.log(JSON.parse(response.responseText));

                errors = JSON.parse(response.responseText);
                $.each(errors, function( index, error ) {
                  //alert( index + ": " + value );
                  $('input[name='+error.field+']').parent().addClass('has-danger');
                  $('input[name='+error.field+']').addClass('form-control-danger');
                });
            }
          });


          //e.preventDefault(); // avoid to execute the actual submit of the form.
          return false;
        });

    $(document).ready(function() { 

        
      
    });
    </script>

  </body>
</html>