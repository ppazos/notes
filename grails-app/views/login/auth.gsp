<!DOCTYPE html>
<html>
  <head>
    <meta name="layout" content="notes-modal" />
    <title><g:message code="login.card.title" /></title>
    <asset:stylesheet src="login.css"/>
  </head>
  <body>
    <div class="row">
      <div class="col-md-4 offset-md-4">
        <div class="login-panel card">
          <div class="card-header">
            <g:message code="login.card.title" />
          </div>
          <div class="card-block">
            <g:if test="${flash.message}">
              <div class="login_message">${flash.message}</div><br/>
            </g:if>
            <form  action="${postUrl ?: '/login/authenticate'}" method="POST" id="loginForm" class="cssform" autocomplete="off">
              <fieldset>
                  <div class="form-group">
                    <label for="username"><g:message code="login.username.label"/></label>
                    <input type="text" class="form-control" name="username" id="username" required="required" autofocus="true" />
                  </div>
                  <div class="form-group">
                    <label for="password"><g:message code="login.password.label"/></label>
                    <input type="password" class="form-control" name="password" id="password" required="required" value="" />
                  </div>
                  
                  <input type="submit" id="submit" class="btn btn-lg btn-success btn-block" value="${message(code: 'login.button.text')}"/>
                  
                  <!--
                  <div class="form-group" style="margin:0; padding:15px 0 15px 0; text-align:center;">
                    <g:link controller="user" action="forgotPassword">
                      <g:message code="springSecurity.login.forgotPassword.label"/>
                    </g:link>
                  </div>
                  -->
              </fieldset>
            </form>
          </div>
        </div>
      </div>
    </div>
  </body>
</html>