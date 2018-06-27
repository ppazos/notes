<!DOCTYPE html>
<html>
  <head>
    <meta name="layout" content="notes-modal" />
    <title><g:message code="feedback.card.title" /></title>
    <asset:stylesheet src="login.css"/>
  </head>
  <body>
    <div class="row">
      <div class="col-md-4 offset-md-4">
        <div align="center" id="logo">
          <asset:image src="hor_margin_white_72_300x87.png" />
        </div>
        <div class="login-panel card">
          <div class="card-header">
            <g:message code="feedback.card.title" />
          </div>
          <div class="card-body">
            <g:feedbackPlain />
            <div style="margin:0; padding:15px 0 0 0; text-align:center;">
              <g:link controller="login">
                <g:message code="back.login.action"/>
              </g:link>
            </div>
          </div>
        </div>
      </div>
    </div>
  </body>
</html>
