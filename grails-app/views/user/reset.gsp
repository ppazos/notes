<!DOCTYPE html>
<html>
  <head>
    <meta name="layout" content="notes-modal" />
    <title><g:message code="reset.card.title" /></title>
    <asset:stylesheet src="login.css"/>
  </head>
  <body>
    <div class="row">
      <div class="col-md-4 offset-md-4">
        <div class="login-panel card">
          <div class="card-header">
            <g:message code="reset.card.title" />
          </div>
          <div class="card-block">
            <g:if test="${flash.message}">
              <div class="login_message">${flash.message}</div><br/>
            </g:if>
            <form  action="${createLink(action:'reset')}" method="POST" id="loginForm" class="cssform" autocomplete="off">
              <input type="hidden" name="token" value="${params.token}">
              <fieldset>
                  <div class="form-group ${errors?.password ? 'has-danger':''}">
                    <label for="password"><g:message code="reset.password.label"/></label>
                    <input type="text" class="form-control ${errors?.password ? 'form-control-danger':''}" name="password" id="password" required="required" autofocus="true" value="${params.password}" />
                    <g:if test="${errors?.password}">
                       <small class="form-control-feedback"><g:message code="user.password.${errors.password.code}" /></small>
                     </g:if>
                  </div>
                  <div class="form-group ${errors?.confirm ? 'has-danger':''}">
                    <label for="confirm"><g:message code="reset.confirm.label"/></label>
                    <input type="text" class="form-control ${errors?.confirm ? 'form-control-danger':''}" name="confirm" id="confirm" required="required" value="${params.confirm}" />
                    <g:if test="${errors?.confirm}">
                       <small class="form-control-feedback"><g:message code="user.confirm.${errors.confirm.code}" /></small>
                     </g:if>
                  </div>
                  
                  <input type="submit" id="submit" name="submit" class="btn btn-lg btn-success btn-block" value="${message(code: 'reset.button.text')}"/>

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