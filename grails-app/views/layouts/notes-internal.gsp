<!doctype html>
<html lang="en" class="no-js">
  <head>
    <!-- needed by Bootstrap 4 -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <asset:link rel="shortcut icon" href="favicon.ico" type="image/x-icon"/>

    <asset:link rel="apple-touch-icon" sizes="180x180" href="apple-touch-icon.png"/>
    <asset:link rel="icon" type="image/png" sizes="32x32" href="favicon-32x32.png"/>
    <asset:link rel="icon" type="image/png" sizes="16x16" href="favicon-16x16.png"/>

    <link rel="manifest" href="/site.webmanifest"/>

    <asset:link rel="mask-icon" href="safari-pinned-tab.svg" color="#8274C1"/>

    <meta name="apple-mobile-web-app-title" content="PsiSix Notes"/>
    <meta name="application-name" content="PsiSix Notes"/>
    <meta name="msapplication-TileColor" content="#8274C1"/>

    <!-- Chrome, Firefox OS and Opera -->
    <meta name="theme-color" content="#8274C1"/>
    <!-- Windows Phone -->
    <meta name="msapplication-navbutton-color" content="#8274C1"/>
    <!-- iOS Safari -->
    <meta name="apple-mobile-web-app-status-bar-style" content="#8274C1"/>

    <title>
      <g:layoutTitle default="PsiSix"/>
    </title>
    <!-- Bootstrap 4 beta -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" integrity="sha384-WskhaSGFgHYWDcbwN70/dfYBj47jz9qbsMId/iRN3ewGhXQFZCSftd1LZCfmhktB" crossorigin="anonymous">

    <script src="https://code.jquery.com/jquery-3.2.1.min.js" integrity="sha256-hwg4gsxgFZhOsEEamdOYGBf13FyQuiTwlAQgxVSNgt4=" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js" integrity="sha384-smHYKdLADwkXOn1EmN1qk/HfnUcbVRZyYmZ4qpPea6sjB/pTJ0euyQp0Mk8ck+5T" crossorigin="anonymous"></script>

    <asset:stylesheet src="font-awesome.min.css"/>
    <asset:stylesheet src="notes.css"/>
    <link href="//fonts.googleapis.com/css?family=Roboto" rel="stylesheet" />

    <g:layoutHead/>

    <style>
    /* show 100% H main bg white */
    html, body, .container-fluid, .container-fluid > .row, main {
      height: 100%;
      font-family: 'Roboto', sans-serif;
    }
    main {
      overflow: auto; /* expands the container to the contents length, fixes a problem in responsive for note list */
    }
    /* show menu 100% H bg lavender */
    body {
      background-color: #8274C1;
    }

    /* fix anchor color, same as btn-primary, also for hover. that is on notes.css */
    a {
      color: #9B8FCD;
    }
    a:hover {
      color: #8274C1;
    }
    a, a:hover, a:active, a:visited, button {
      cursor: pointer !important;
    }

    nav > div {
      margin: 0
    }
    .navbar {
      background-color: #8274C1; /* lavender dark */
      /*padding:  10px 15px 0 15px;*/
      padding: 0;
      margin: 0;
    }
    #menu {
      background-color: #9B8FCD; /* lavender light */
    }
    #menu > div {
      padding: 0;
    }
    #menu li a {
      padding: 10px 15px;
      color: #fff;
    }
    #menu li a.active {
      /*border-left: 3px solid #fff;*/
      color: #9B8FCD;
      background-color: #fff;
      /*border-left: 3px solid #9B8FCD;
      padding-left: 12px; *//* keeps menu items aligment when left boder is shown */
    }
    main {
      padding: 10px;
      background-color: #fff;
    }
    main > div:first-child {
      margin-bottom: 15px;
    }

    /* Small viewport or below */
    @media (max-width : 767px) {
      .navbar-toggler {
        display: inline;
        top: 10px; /* adjust vertical position to middle top bar */
      }
      .navbar {
        max-width: 100%;
      }
      #menu {
        display: none;
      }
      #menu.collapse.show, #menu.collapsing {
        display: block;
      }
    }
    /* medium or above */
    @media (min-width : 768px) {
      #menu {
        display: block;
      }
    }

    .pagination {
      border: 1px solid #8274C1;
    }
    .pagination > * {
      padding: 5px 10px;
    }
    .pagination > .currentStep {
      background-color: #8274C1;
      color: #FFF;
    }

    /* Buttons calendar
    ------------------------------------------------------------------------*/
    button.fc-button {
      border-color: #9675ce;
      color: #9675ce;
    }

    :focus {
      outline: none;
    }
    /*
    button.fc-button:active, button.fc-button:focus {
      outline: none !important; / * removes blue outline when calendar header buttons are clicked * /
    }
    */
    .fc-state-down, .fc-state-active {
      background-color: #9675ce !important;
      color: #FFF !important;
    }
    .fc .fc-header-space {
      padding-left: 10px;
    }
    /* buttons edges butting together */

    .fc-header .fc-button {
      margin-right: -1px;
    }

    .fc-header .fc-corner-right,  /* non-theme */
    .fc-header .ui-corner-right { /* theme */
      margin-right: 0; /* back to normal */
    }

    /* button layering (for border precedence) */

    .fc-header .fc-state-hover,
    .fc-header .ui-state-hover {
      z-index: 2;
    }
    .fc-header .fc-state-down {
      z-index: 3;
    }
    .fc-header .fc-state-active,
    .fc-header .ui-state-active {
      z-index: 4;
    }
    .fc-header .fc-button {
      margin-bottom: 1em;
      vertical-align: top;
    }
    .fc-button {
      position: relative;
      display: inline-block;
      padding: 0 .6em;
      overflow: hidden;
      height: 1.9em;
      line-height: 1.9em;
      white-space: nowrap;
      cursor: pointer;
    }
    .fc-state-default { /* non-theme */
      border: 1px solid;
      background: #fff;
    }
    .fc-state-default {
      border-color: #ff3b30;
      color: #ff3b30;
    }
    .fc-state-default.fc-corner-left { /* non-theme */
      border-top-left-radius: 0;
      border-bottom-left-radius: 0;
    }
    .fc-state-default.fc-corner-right { /* non-theme */
      border-top-right-radius: 0;
      border-bottom-right-radius: 0;
    }

    /*
      Our default prev/next buttons use HTML entities like ‹ › « »
      and we'll try to make them look good cross-browser.
    */

    .fc-text-arrow {
      margin: 0 .4em;
      font-size: 2em;
      line-height: 23px;
      vertical-align: baseline; /* for IE7 */
    }

    .fc-button-prev .fc-text-arrow,
    .fc-button-next .fc-text-arrow { /* for ‹ › */
      font-weight: bold;
    }

    /* icon (for jquery ui) */

    .fc-button .fc-icon-wrap {
      position: relative;
      float: left;
      top: 50%;
    }
    .fc-button .ui-icon {
      position: relative;
      float: left;
      margin-top: -50%;

      *margin-top: 0;
      *top: -50%;
    }

    .fc-button-month.fc-state-default, .fc-button-agendaWeek.fc-state-default, .fc-button-agendaDay.fc-state-default{
      min-width: 67px;
      text-align: center;
      transition: all 0.2s;
      -webkit-transition: all 0.2s;
    }
    .fc-state-hover,
    .fc-state-down,
    .fc-state-active,
    .fc-state-disabled {
      color: #333333;
      /*background-color: #FFE3E3;*/
    }

    .fc-state-hover {
      color: #ff3b30;
      text-decoration: none;
    }

    .fc-state-down,
    .fc-state-active {
      background-color: #ff3b30;
      background-image: none;
      outline: 0;
      color: #FFFFFF;
    }

    .fc-state-disabled {
      cursor: default;
      background-image: none;
      background-color: #DDD;
      filter: alpha(opacity=65);
      box-shadow: none;
      border:1px solid #333;
      color: #ff3b30;
    }

    .fc-week .fc-day:hover .fc-day-number{
      background-color: #B8B8B8;
      color: #FFFFFF;
    }
    .fc-week .fc-day.fc-state-highlight:hover .fc-day-number{
      background-color:  #ff3b30;
    }
    .fc-button-today{
      border: 1px solid rgba(255,255,255,.0);
    }
    .fc-view-agendaDay thead tr.fc-first .fc-widget-header{
      text-align: right;
      padding-right: 10px;
    }
    #logo {
      width: 100%;
      max-height: 70px;
      max-width: 257px;
    }
    /* Small viewport or below */
    @media (max-width : 767px) {
      #logo {
        width: 50%;
      }
    }
    </style>
  </head>
  <body>
    <div class="container-fluid">
      <div class="row">

<!--
        <nav class="navbar navbar-expand-md navbar-dark col-md-2 col-sm-12">
          <a class="navbar-brand" href="#">Navbar</a>
          <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavDropdown">
            <span class="navbar-toggler-icon"></span>
          </button>
          <div class="navbar-collapse collapse" id="navbarNavDropdown">
            <ul class="navbar-nav flex-column">
              <li class="nav-item active">
                <a class="nav-link" href="#">Home <span class="sr-only">(current)</span></a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="#">Features</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="#">Pricing</a>
              </li>
              <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownMenuLink" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                  Dropdown link
                </a>
                <div class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink">
                  <a class="dropdown-item" href="#">Action</a>
                  <a class="dropdown-item" href="#">Another action</a>
                  <a class="dropdown-item" href="#">Something else here</a>
                </div>
              </li>
            </ul>
          </div>
        </nav>
-->


        <nav class="navbar navbar-expand-md col-md-2 col-sm-12">
          <div id="top_bar">
            <img src="${assetPath(src:'hor_margin_white_72_300x87.png')}" class="align-middle" alt="PsiSix Notes" id="logo" />
            <div class="navbar-toggler-containder pull-right">
              <button class="navbar-toggler align-middle" type="button" data-toggle="collapse" data-target="#menu"><i class="fa fa-bars" aria-hidden="true"></i></button>
            </div>
          </div>
          <div class="navbar-collapse collapse" id="menu">
            <ul class="navbar-nav flex-column">
              <li class="nav-item">
                <g:link controller="dashboard" action="index" class="nav-link ${(controllerName=='dashboard')?'active':''}"><i class="fa fa-tachometer fa-fw" aria-hidden="true"></i> <g:message code="menu.dashboard"/></g:link>
              </li>
              <li class="nav-item">
                <g:link controller="patient" action="index" class="nav-link ${(['patient', 'note'].contains(controllerName))?'active':''}"><i class="fa fa-user-circle-o fa-fw" aria-hidden="true"></i> <g:message code="menu.patients"/></g:link>
              </li>
              <li class="nav-item">
                <g:link controller="timeSlot" action="index" class="nav-link ${(controllerName=='timeSlot')?'active':''}"><i class="fa fa-calendar fa-fw" aria-hidden="true"></i> <g:message code="menu.agenda"/></g:link>
              </li>
              <li class="nav-item">
                <g:link controller="payments" action="index" class="nav-link ${(['payments'].contains(controllerName))?'active':''}"><i class="fa fa-dollar fa-fw" aria-hidden="true"></i> <g:message code="menu.payments"/></g:link>
              </li>
              <li class="nav-item">
                <g:link controller="noteCategory" action="index" class="nav-link ${(controllerName=='noteCategory')?'active':''}"><i class="fa fa-th-list fa-fw" aria-hidden="true"></i> <g:message code="menu.categories"/></g:link>
              </li>
              <li class="nav-item">
                <g:link controller="logout" class="nav-link"><i class="fa fa-sign-out fa-fw" aria-hidden="true"></i> <g:message code="menu.logout"/></g:link>
              </li>
              <sec:ifAnyGranted roles="ROLE_ADMIN">
                <li class="nav-item admin">
                  <g:link controller="user" action="index" class="nav-link ${(controllerName=='user')?'active':''}"><i class="fa fa-user-circle-o fa-fw" aria-hidden="true"></i> <g:message code="menu.users"/></g:link>
                </li>
              </sec:ifAnyGranted>
              <li class="nav-item app_version">
                v${grailsApplication.config.getProperty('info.app.version')}
              </li>
            </ul>
          </div>
        </nav>

        <main class="col-md-10 col-sm-12">
          <g:layoutBody/>
        </main>
      </div>
    </div>
    <script>
      // attaches event to dynamically loaded list pagination
      $(document.body).on('click', '.pagination > a', function(e) {

        console.log(e.target.href);
        $.get(e.target.href, function (data) {
          $('#list_container').html(data); // TODO: id other list containers with the same id, this works for notes only!!!
        });

        e.preventDefault();
      });

      $(document).ready(function() {

        // Solution for disabling the submit temporarily for all the submit buttons.
        // Avoids double form submit.
        // Doing it directly on the submit click made the form not to submit in Chrome.
        // This works in FF and Chrome.
        $('form').on('submit', function(e){
          //console.log('submit2', e, $(this).find('[clicked=true]'));

          var submit = $(this).find('[clicked=true]')[0];

          if (!submit.hasAttribute('disabled'))
          {
            submit.setAttribute('disabled', true);

            setTimeout(function(){
              submit.removeAttribute('disabled');
            }, 1000);
          }

          submit.removeAttribute('clicked');

          e.preventDefault();
        });
        $('[type=submit]').on('click touchstart', function(){
          this.setAttribute('clicked', true);
        });
      });
    </script>
  </body>
</html>
