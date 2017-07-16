<!DOCTYPE html>
<html>
  <head>
    <meta name="layout" content="notes-internal" />
    <title><g:message code="note.index.title" /></title>
    <style>
      .modal-body {
        padding: 0;
      }
    </style>
  </head>
  <body>
  <!--
    <div class="row">
      <div class="col">
        <div class="nav" role="navigation">
          <ul>
            <li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label" /></a></li>
          </ul>
        </div>
      </div>
    </div>
    -->
    <div class="row">
      <div class="col">

        <!-- Button trigger modal -->
        <span class="float-right">
          <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#myModal">
          + Note
          </button>
        </span>

        <!-- Modal -->
        <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
          <div class="modal-dialog modal-lg" role="document">
            <g:form action="save">
              <input type="hidden" name="pid" value="${params.pid}" />
              <div class="modal-content">
                <div class="modal-header">
                  <h5 class="modal-title" id="exampleModalLabel">New note</h5>
                  <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                  </button>
                </div>
                <div class="modal-body">
                  <textarea id="editor" name="text"></textarea>
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
        <%
        def cols = 1
        def list = noteList.collect() // new list
        def row = list.take(cols)
        %>
        <g:while test="${list}">
          <div class="card-deck"><!-- card-columns = masonry -->
            <g:each in="${row}" var="note">

                <div class="card">
                  <!--<img class="card-img-top" src="..." alt="Card image cap">-->
                  <div class="card-block">
                    <h4 class="card-title">${note.id} ${note.dateCreated}</h4>
                    <p class="card-text">
                      ${note.text.encodeAsRaw()}
                    </p>
                  </div>
                  <div class="card-footer card-${note.color}">
                  </div>
                </div>
            </g:each>
          </div>
          <br/>
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
           border: 0
        }).then(function(editors){
          $('.mce-tinymce').css('border','0');
        });
      });
    </script>
  </body>
</html>