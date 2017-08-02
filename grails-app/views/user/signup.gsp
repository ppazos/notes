<!DOCTYPE html>
<html>
  <head>
    <meta name="layout" content="notes-modal" />
    <title><g:message code="signup.card.title" /></title>
    <asset:stylesheet src="login.css"/>
  </head>
  <body>
    <div class="row">
      <div class="col-md-4 offset-md-4">
        <div class="login-panel card">
          <div class="card-header">
            <g:message code="signup.card.title" />
          </div>
          <div class="card-block">
            <g:if test="${flash.message}">
              <div class="login_message">${flash.message}</div><br/>
            </g:if>
            <form  action="${createLink(action:'signup')}" method="POST" id="loginForm" class="cssform" autocomplete="off">
              <fieldset>
                  <div class="form-group ${errors?.name ? 'has-danger':''}">
                    <label for="name"><g:message code="signup.name.label"/></label>
                    <input type="text" class="form-control ${errors?.name ? 'form-control-danger':''}" name="name" id="name" required="required" autofocus="true" value="${params.name}" />
                  </div>
                  <div class="form-group ${errors?.lastname ? 'has-danger':''}">
                    <label for="lastname"><g:message code="signup.lastname.label"/></label>
                    <input type="text" class="form-control ${errors?.lastname ? 'form-control-danger':''}" name="lastname" id="lastname" required="required" value="${params.lastname}" />
                  </div>
                  <div class="form-group ${errors?.username ? 'has-danger':''}">
                    <label for="username"><g:message code="signup.email.label"/></label>
                    <input type="email" class="form-control ${errors?.username ? 'form-control-danger':''}"
                     name="username" id="username" required="required" value="${params.username}" />
                  </div>

                  
                  <input type="submit" id="submit" class="btn btn-lg btn-success btn-block" value="${message(code: 'signup.button.text')}"/>
                  
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