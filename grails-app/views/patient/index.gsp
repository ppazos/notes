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

        <h1><g:message code="default.list.label" args="[entityName]" /></h1>
        <g:if test="${flash.message}">
          <div class="message" role="status">${flash.message}</div>
        </g:if>
      </div>
    </div>

    <div class="row">
      <div class="col">
        <table class="table">
          <thead>
            <tr>
              <th>First Name</th>
              <th>Last Name</th>
              <th>Dob</th>
              <th>Sex</th>
            </tr>
          </thead>
          <tbody>
            <g:each in="${patientList}" var="p">
              <tr>
                <td>
                  <g:link controller="note" action="index" params="[pid: p.id]">${p.name}</g:link>
                </td>
                <td>${p.lastname}</td>
                <td>${p.dob}</td>
                <td>${p.sex}</td>
              </tr>
            </g:each>
          </tbody>
        </table>

        <div class="pagination">
          <g:paginate total="${patientCount ?: 0}" />
        </div>
      </div>
    </div>
  </body>
</html>