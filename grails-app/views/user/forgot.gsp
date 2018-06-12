<!DOCTYPE html>
<html>
  <head>
    <meta name="layout" content="notes-modal" />
    <title><g:message code="forgot.card.title" /></title>
    <asset:stylesheet src="login.css"/>
  </head>
  <body>
    <div class="row">
      <div class="col-md-4 offset-md-4">
        <div class="locale-selector-container text-center">
          <g:localeSelector uri="${request.forwardURI}" />
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col-md-4 offset-md-4">
        <div align="center" id="logo">
          <asset:image src="hor_margin_white_72_300x87.png" />
        </div>
        <div class="login-panel card">
          <div class="card-header">
            <g:message code="forgot.card.title" />
          </div>
          <div class="card-body">
            <g:if test="${flash.message}">
              <div class="login_message">${flash.message}</div><br/>
            </g:if>
            <form  action="${createLink(action:'forgot')}" method="POST" id="loginForm" class="cssform" autocomplete="off">
              <fieldset>
                  <div class="form-group ${errors?.email ? 'is-invalid':''}">
                    <label for="email"><g:message code="forgot.email.label"/></label>
                    <input type="email" class="form-control ${errors?.email ? 'is-invalid':''}" name="email" id="email" required="required" value="${params.email}" />
                     <g:if test="${errors?.email}">
                       <small class="form-control-feedback"><g:message code="user.username.${errors.email.code}" /></small>
                     </g:if>
                  </div>

                  <input type="submit" id="submit" name="submit" class="btn btn-lg btn-success btn-block" value="${message(code: 'forgot.button.text')}"/>

                  <div class="form-group" style="margin:0; padding:15px 0 0 0; text-align:center;">
                    <g:link controller="login">
                      <g:message code="back.action"/>
                    </g:link>
                  </div>

              </fieldset>
            </form>
          </div>
        </div>
      </div>
    </div>
  </body>
</html>
