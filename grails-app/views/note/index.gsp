<!DOCTYPE html>
<html>
  <head>
    <meta name="layout" content="notes-internal" />
    <title><g:message code="note.index.title" /></title>
    <style>
    /*
      .modal-body {
        padding: 0;
      }
      */
      /*
      .modal-body > .form-group {
        padding: 15px;
      }
      */
      .nav {
        margin-bottom: 10px;
        padding-top: 5px;
        padding-left: 3px;
        padding-right: 3px;
        background-color: #8274C1;
      }
      .nav > .nav-item { /* space between tabs */
        margin-left: 2px;
        margin-right: 2px;
      }
      .nav > .nav-item > a {
        color: #FFF;
      }
      .zero-state-container {
        height: 300px;
        display: -webkit-flex;
        display: flex;
        -webkit-align-items: center;
        -align-items: center;
        -webkit-justify-content: center;
        justify-content: center;
      }
      .zero-state {
        color: #DDD;
      }
    </style>
  </head>
  <body>
    <div class="row">
      <div class="col">

        <!-- Button trigger modal -->
        <span class="float-right">
          <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#create_modal">
          + Note
          </button>
        </span>

        <!-- Modal -->
        <div class="modal fade" id="create_modal" tabindex="-1" role="dialog" aria-labelledby="create_modal_label" aria-hidden="true">
          <div class="modal-dialog modal-lg" role="document">
            <g:form url="[action:'save']" id="create_form">
              <input type="hidden" name="pid" value="${params.pid}" />
              <div class="modal-content">
                <div class="modal-header">
                  <h5 class="modal-title" id="create_modal_label">New note</h5>
                  <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                  </button>
                </div>
                <div class="modal-body">
                  <div class="form-group">
                    <textarea id="editor" name="text"></textarea>
                  </div>
                  <div class="form-group">
                    <label for="name">Category</label>
                    <g:select name="category" class="form-control" from="${categories}" optionKey="id" optionValue="name" noSelection="['null':'Uncategorized']" />
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
        
        <h1><g:message code="note.index.title" /></h1>
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
        <div class="card">
          <div class="card-header">
            <div class="row">
              <div class="col-4">
                <i class="fa fa-user-circle-o fa-4x" aria-hidden="true"></i>
              </div>
              <div class="col-8 text-right">
                ${patient.name} ${patient.lastname} (${patient.sex})
              </div>
            </div>
          </div>
          <!--
          <div class="card-footer">
          foot
          </div>
          -->
        </div>
      </div>
    </div>


    <%-- params received by index are sent to note_list automatically --%>
    <div id="list_container">
    <g:include action="note_list" />
    </div>

    <asset:javascript src="tinymce/tinymce.min.js"/>
    <script>
      $(document).ready(function() {
        tinymce.init({
           selector:'#editor',
           height: 400,
           resize: false,
           menubar: false,
           branding: false,
           //border: 0
        }).then(function(editors){
          //$('.mce-tinymce').css('border','0');
        });
      });

      $("#create_form").submit(function(e) {

        var url = this.action;

        // Reset validation
        $('input').parent().removeClass('has-danger');
        $('input').removeClass('form-control-danger');

        // makes tinyMCE to save the content to the textarea for submit
        // without this, the first submit has empty text
        tinyMCE.get("editor").save();

        $.ajax({
          type: "POST",
          url: url,
          data: $("#create_form").serialize(),
          success: function(data, statusText, response)
          {
            console.log(data);
            // Update patient table with new patient
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
              $('[name='+error.field+']').parent().addClass('has-danger'); // shows border on form-control children
              $('[name='+error.field+']').addClass('form-control-danger'); // shows icon if input

              if (error.field == 'text') $('.mce-tinymce').addClass('form-control'); // shows border
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