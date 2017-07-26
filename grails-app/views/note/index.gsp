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
                    <g:select name="category" class="form-control" from="${categories}" optionKey="id" optionValue="name" />
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
        <ul class="nav nav-tabs nav-fill flex-column flex-sm-row">
          <g:each in="${categories}" var="_category">
            <li class="nav-item">
              <a class="nav-link ${category.name == _category.name ? 'active' : ''}" href="${createLink(action:'index', params:[categoryName:_category.name, pid: params.pid])}">${_category.name}</a>
            </li>
          </g:each>
          <li class="nav-item">
            <a class="nav-link ${category == null ? 'active' : ''}" href="#">Uncategorized</a>
          </li>
        </ul>
      </div>
    </div>

    <div class="row">
      <div class="col">

       <g:if test="${!noteList}">
         <div class="zero-state-container">
           <h1 class="zero-state">Ups! we don't have any notes here.</h1>
         </div>
       </g:if>

        <%
        def cols = 2
        def list = noteList.collect() // new list
        def row = list.take(cols)
        %>
        <g:while test="${list}">
          <div class="card-deck"><!-- card-columns = masonry -->
            <g:each in="${row}" var="note">
              <div class="card">
                <div class="card-header">
                  ${note.id} ${note.dateCreated}
                </div>
                <div class="card-block">
                  <p class="card-text">
                    ${note.text.encodeAsRaw()}
                  </p>
                </div>
                <div class="card-footer card-${note.color}">
                </div>
              </div>
            </g:each>
          </div>
          <%
            list = list.drop(cols)
            row = list.take(cols)
          %>
        </g:while>

        <div class="pagination">
          <g:paginate total="${noteCount ?: 0}" />
        </div>
      </div>
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

        $.ajax({
          type: "POST",
          url: url,
          data: $("#create_form").serialize(),
          success: function(data, statusText, response)
          {
            // Update patient table with new patient
            $('#table').html(data);
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