<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'note.label', default: 'Note')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
        <style>
          .modal-body {
            padding: 0;
          }
        </style>
    </head>
    <body>
        <a href="#list-note" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
        <div class="nav" role="navigation">
            <ul>
                <li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
                <li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
            </ul>
        </div>
        <div id="list-note" class="content scaffold-list" role="main">
            <h1><g:message code="default.list.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
                <div class="message" role="status">${flash.message}</div>
            </g:if>

            <!-- Button trigger modal -->
            <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#myModal">
              + Note
            </button>

            <!-- Modal -->
            <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
              <div class="modal-dialog modal-lg" role="document">
                <g:form action="save">
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

            <%
            def cols = 3
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