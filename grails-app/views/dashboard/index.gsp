<!DOCTYPE html>
<html>
  <head>
    <meta name="layout" content="notes-internal" />
    <title><g:message code="dashboard.index.title" /></title>
    <style type="text/css">
      .dashboard-number {
        font-size: 1.8em
      }
      .fa-dash {
        font-size: 4em;
      }
      @media (max-width : 767px) {
        .dashboard-number {
          font-size: 1.4em
        }
        .fa-dash {
          font-size: 3.5em;
        }
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
      <div class="col-sm-6">
        <div class="card">
          <div class="card-header">
            <div class="row">
              <div class="col-6">
                <i class="fa fa-user-circle-o fa-dash" aria-hidden="true"></i>
              </div>
              <div class="col-6 text-right">
                <div class="dashboard-number">${patients}</div>
                <div><g:message code="dashboard.patients.label"/></div>
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

      <div class="col-sm-6">
        <div class="card">
          <div class="card-header">
            <div class="row">
              <div class="col-6">
                <i class="fa fa-file-text-o fa-dash" aria-hidden="true"></i>
              </div>
              <div class="col-6 text-right">
                <div class="dashboard-number">${notes}</div>
                <div><g:message code="dashboard.notes.label"/></div>
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

    <div class="row">
      <div class="col-sm-6">
        <div class="card">
          <div class="card-header">
            <div class="row">
              <div class="col-6">
                <i class="fa fa-calendar fa-dash" aria-hidden="true"></i>
              </div>
              <div class="col-6 text-right">
                <div class="dashboard-number">${slots}</div>
                <div><g:message code="dashboard.slots.label"/></div>
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

      <div class="col-sm-6">
        <div class="card">
          <div class="card-header">
            <div class="row">
              <div class="col-6">
                <i class="fa fa-dollar fa-dash" aria-hidden="true"></i>
              </div>
              <div class="col-6 text-right">
                <div class="dashboard-number">${payments}</div>
                <div><g:message code="dashboard.payments.label"/></div>
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

    <div class="row">
      <div class="col">
        <g:message code="dashboard.index.quickguide" />
      </div>
    </div>
  </body>
</html>
