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
          <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#create_modal">
          + Category
          </button>
        </span>
        
        <!-- Modal -->
        <div class="modal fade" id="create_modal" tabindex="-1" role="dialog" aria-labelledby="create_modal_label" aria-hidden="true">
          <div class="modal-dialog modal-lg" role="document">
            <g:form action="save">
              <div class="modal-content">
                <div class="modal-header">
                  <h5 class="modal-title" id="create_modal_label">New category</h5>
                  <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                  </button>
                </div>
                <div class="modal-body">
                  <div class="form-group">
                    <label for="name">Name</label>
                    <input type="text" class="form-control" id="name" name="name" />
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
        <%--<f:table collection="${noteCategoryList}" class="table" />--%>

        <table class="table">
          <thead>
            <tr>
              <th>Name</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            <g:each in="${noteCategoryList}" var="c">
              <tr>
                <td>${c.name}</td>
                <td></td>
              </tr>
            </g:each>
          </tbody>
        </table>

        <div class="pagination">
          <g:paginate total="${noteCategoryCount ?: 0}" />
        </div>
      </div>
    </div>
  </body>
</html>
