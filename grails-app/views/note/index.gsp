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
      .card {
        margin-bottom: 10px !important;
      }
      div.card-body {
        margin-bottom: 24px; /* fix margin bottom from the footer */
      }
      div.card-footer { /* fix for footer going up in the card when content is small */
        bottom: 0;
        position: absolute;
        width: 100%;
      }
      .notes-layout-selector {
        margin-bottom: 10px;  
      }
      .btn.notes-layout {

      }
      .btn.notes-layout span {
        width: 1em;
        display: inline-block;
        font-size: 1.25em;
        font-weight: bold;
      }
    </style>
  </head>
  <body>
    <div class="row">
      <div class="col">

        <!-- Button trigger modal -->
        <span class="float-right">
          <button type="button" class="btn btn-primary btn-create"> + </button>
        </span>

        <!-- Modal -->
        <div class="modal fade" id="create_modal" tabindex="-1" role="dialog" aria-labelledby="create_modal_label" aria-hidden="true">
          <div class="modal-dialog modal-lg" role="document">
            <g:form url="[action:'save']" id="create_form">
              <input type="hidden" name="pid" value="${params.pid}" />
              <div class="modal-content">
                <div class="modal-header">
                  <h5 class="modal-title" id="create_modal_label"><g:message code="note.new.title"/></h5>
                  <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                  </button>
                </div>
                <div class="modal-body">
                  <div class="form-group">
                    <textarea id="editor" name="text"></textarea>
                  </div>
                  <div class="form-group">
                    <label for="name"><g:message code="note.attr.category"/></label>
                    <g:select name="category" class="form-control" from="${categories}" optionKey="id" optionValue="name" noSelection="['null':'Uncategorized']" />
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

        <h1><g:message code="note.index.title" /></h1>
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
        <div class="card">
          <div class="card-header">
            <div class="row">
              <div class="col-4">
                <i class="fa fa-user-circle-o fa-4x" aria-hidden="true"></i>
              </div>
              <div class="col-8 text-right">
                ${patient.name} ${patient.lastname} (${patient.sex}) <g:formatDate date="${patient.dob}" type="date" style="MEDIUM"/>
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
        $('.btn-create').on('click', function(){
          $.ajax({
            type: "GET",
            url: "${createLink(controller:'plan', action:'canCreateNote')}",
            data: $("#create_form").serialize(),
            success: function(data, statusText, response)
            {
              console.log(data);

              if (data.result) // true: can create notes
              {
                $('#create_modal').modal('show');
              }
              else
              {
                $('main .row > .col:first').append('<div class="alert alert-custom fade in alert-dismissable show"><button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true" style="font-size:20px">&times;</span></button>'+ data.message +'</div>');
              }
            }
          });
        });

        tinymce.init({
           selector:'#editor',
           height: 400,
           resize: false,
           menubar: false,
           branding: false,
           forced_root_block : "" // avoids adding extra P element to the text
           //border: 0
        }).then(function(editors){
          //$('.mce-tinymce').css('border','0');
        });
      });

      $("#create_form").submit(function(e) {

        var url = this.action;

        // Reset validation
        $('input').removeClass('is-invalid');

        // makes tinyMCE to save the content to the textarea for submit
        // without this, the first submit has empty text
        tinyMCE.get("editor").save();

        $.ajax({
          type: "POST",
          url: url,
          data: $("#create_form").serialize(),
          success: function(data, statusText, response)
          {
            //console.log(data);
            // Update patient table with new patient
            $('#list_container').html(data);
            $('#create_modal').modal('hide');
          },
          error: function(response, statusText)
          {
            //console.log(JSON.parse(response.responseText));

            // Display validation errors on for fields
            errors = JSON.parse(response.responseText);
            // error: 1. user doesn't have plan, 2. can't create patient
            if(errors.hasOwnProperty('result') && errors.result == false)
            {
              $('#create_modal .modal-body').prepend('<div class="alert alert-custom fade in alert-dismissable show"><button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true" style="font-size:20px">&times;</span></button>'+ errors.message +'</div>');
            }
            else // data validation error
            {
              $.each(errors, function( index, error ) {
                console.log(error.defaultMessage);
                if (error.field == 'text') $('.mce-tinymce').addClass('form-control').addClass('is-invalid'); // shows border
                else $('[name='+error.field+']').addClass('is-invalid');
              });
            }
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

        // focus specific for tinyMCE
        tinymce.execCommand('mceFocus',false,'editor');
      });

      /* layout */
      $('#list_container').on('click', '.notes-layout-1', function(){
        $.ajax({
          type: "POST",
          url: "${createLink(action:'note_list')}",
          data: {columns:1, pid:'${params.pid}'},
          success: function(data, statusText, response)
          {
            $('#list_container').html(data);
          }
        });
      });
      $('#list_container').on('click', '.notes-layout-2', function(){
        $.ajax({
          type: "POST",
          url: "${createLink(action:'note_list')}",
          data: {columns:2, pid:'${params.pid}'},
          success: function(data, statusText, response)
          {
            $('#list_container').html(data);
          }
        });
      });
      $('#list_container').on('click', '.notes-layout-3', function(){
        $.ajax({
          type: "POST",
          url: "${createLink(action:'note_list')}",
          data: {columns:3, pid:'${params.pid}'},
          success: function(data, statusText, response)
          {
            $('#list_container').html(data);
          }
        });
      });
    </script>
  </body>
</html>
