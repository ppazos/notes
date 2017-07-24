<!DOCTYPE html>
<html>
  <head>
    <meta name="layout" content="notes-internal" />
    <title><g:message code="dashboard.index.title" /></title>
    <style type="text/css">
      .dashboard-number {
        font-size: 1.8em
      }

    </style>
  </head>
  <body>
    <div class="row">
      <div class="col">
        <h1><g:message code="dashboard.index.title" /></h1>
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
      <div class="col-6">

        <div class="card">
          <div class="card-header">
            <div class="row">
              <div class="col-6">
                <i class="fa fa-user-circle-o fa-fw fa-4x" aria-hidden="true"></i>
              </div>
              <div class="col-6 text-right">
                <div class="dashboard-number">${patients}</div>
                <div>Patients</div>
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

      <div class="col-6">

        <div class="card">
          <div class="card-header">
            <div class="row">
              <div class="col-6">
                <i class="fa fa-file-text-o fa-fw fa-4x" aria-hidden="true"></i>
              </div>
              <div class="col-6 text-right">
                <div class="dashboard-number">${notes}</div>
                <div>Notes</div>
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
  </body>
</html>
