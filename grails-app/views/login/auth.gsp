<!DOCTYPE html>
<html>
  <head>
    <meta name="layout" content="notes-modal" />
    <g:set var="entityName" value="${message(code: 'patient.label', default: 'Patient')}" />
    <title><g:message code="default.list.label" args="[entityName]" /></title>

    <style type='text/css' media='screen'>
    .login-panel {
      margin-top: 15%;
    }
    #login {
      margin: 15px 0px;
      padding: 0px;
      text-align: center;
    }
  
    #login .inner {
      width: 340px;
      padding-bottom: 6px;
      margin: 60px auto;
      text-align: left;
      border: 1px solid #aab;
      background-color: #f0f0fa;
      -moz-box-shadow: 2px 2px 2px #eee;
      -webkit-box-shadow: 2px 2px 2px #eee;
      -khtml-box-shadow: 2px 2px 2px #eee;
      box-shadow: 2px 2px 2px #eee;
    }
  
    #login .inner .fheader {
      padding: 18px 26px 14px 26px;
      background-color: #f7f7ff;
      margin: 0px 0 14px 0;
      color: #2e3741;
      font-size: 18px;
      font-weight: bold;
    }
  
    #login .inner .cssform p {
      clear: left;
      margin: 0;
      padding: 4px 0 3px 0;
      padding-left: 105px;
      margin-bottom: 20px;
      height: 1%;
    }
  
    #login .inner .cssform input[type='text'] {
      width: 120px;
    }
  
    #login .inner .cssform label {
      font-weight: bold;
      float: left;
      text-align: right;
      margin-left: -105px;
      width: 110px;
      padding-top: 3px;
      padding-right: 10px;
    }
  
    #login #remember_me_holder {
      padding-left: 120px;
    }
  
    #login #submit {
      margin-left: 15px;
    }
  
    #login #remember_me_holder label {
      float: none;
      margin-left: 0;
      text-align: left;
      width: 200px
    }
  
    #login .inner .login_message {
      padding: 6px 25px 20px 25px;
      color: #c33;
    }
  
    #login .inner .text_ {
      width: 120px;
    }
  
    #login .inner .chk {
      height: 12px;
    }
    </style>
  </head>
  <body>
    <div class="row">
      <div class="col-md-4 offset-md-4">
        <div class="login-panel card">
          <div class="card-header">
            <g:message code="login.card.title" />
          </div>
          <div class="card-block">
            <g:if test='${flash.message}'>
              <div class='login_message'>${flash.message}</div><br/>
            </g:if>
            <form  action="${postUrl ?: '/login/authenticate'}" method="POST" id="loginForm" class="cssform" autocomplete="off">
              <fieldset>
                  <div class="form-group">
                    <label for='username'><g:message code="login.username.label"/></label>
                    <input type='text' class='form-control' name='username' id='username' required="required" />
                  </div>
                  <div class="form-group">
                    <label for='password'><g:message code="login.password.label"/></label>
                    <input type='password' class='form-control' name='password' id='password' required="required" value="" />
                  </div>
                  
                  <input type='submit' id="submit" class="btn btn-lg btn-success btn-block" value='${message(code: "login.button.text")}'/>
                  
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
    <script type='text/javascript'>
    (function() {
      document.forms['loginForm'].elements['username'].focus();
    })();
    </script>
  </body>
</html>