<!DOCTYPE html>
<html>
  <head>
    <meta name="layout" content="notes-internal" />
    <title><g:message code="user.index.title" /></title>
  </head>
  <body>
    <div class="row">
      <div class="col">
        <h1><g:message code="user.index.title" /></h1>
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
      <div class="col" id="list_container">
        <g:include action="users_table" />
      </div>
    </div>
  </body>
</html>
