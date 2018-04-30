<!DOCTYPE html>
<html>
  <head>
    <meta name="layout" content="notes-modal" />
    <title><g:message code="login.card.title" /></title>
    <asset:stylesheet src="login.css"/>
    <script>
    var loc = window.location.href+'';
    var parser = document.createElement('a');
    parser.href = loc;
    if (parser.hostname != 'localhost' && !parser.hostname.startsWith('192') && loc.indexOf('http://')==0){
      window.location.href = loc.replace('http://','https://');
    }
    </script>
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
                  <div class="form-group">
                  <input type="submit" id="submit" name="submit" class="btn btn-lg btn-success btn-block" value="${message(code: 'login.button.text')}"/>
                  </div>
                  <div class="form-group" style="margin:0; padding:0 0 0 0; text-align:center;">
                    <g:link controller="user" action="signup">
                      <g:message code="user.signup.action"/>
                    </g:link>
                  </div>
                  <div class="form-group" style="margin:0; padding:15px 0 0 0; text-align:center;">
                    <g:link controller="user" action="forgot">
                      <g:message code="user.reset.action"/>
                    </g:link>
                  </div>
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
    <div class="row logos">
      <div class="col-md-12" align="center">
        <a href="https://cabolabs.com" target="_blank"><asset:image src="CaboLabs.png" height="28"/></a>
        <a href="https://cloudehrserver.com" target="_blank"><asset:image src="EHRServer.png" height="42" /></a>
        <a href="http://openehr.org" target="_blank"><asset:image src="openEHR.png" height="50" /></a>
        <!--<a href="https://www.nirdhost.com" target="_blank"><asset:image src="NIRDHost.png" height="24" /></a>-->
      </div>
    </div>
  </body>
</html>
