<!doctype html>
<html lang="en" class="no-js">
<head>
    <!-- needed by Bootstrap 4 -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>
      <g:layoutTitle default="Grails"/>
    </title>

    <!-- jQuery Slim, needed by Bootstrap 4
    <script src="https://code.jquery.com/jquery-3.1.1.slim.min.js" integrity="sha384-A7FZj7v+d/sdmMqp/nOQwliLvUsJfDHW+k9Omg/a/EheAdgtzNs3hpfag6Ed950n" crossorigin="anonymous"></script>
    -->

    <script
  src="https://code.jquery.com/jquery-3.2.1.min.js"
  integrity="sha256-hwg4gsxgFZhOsEEamdOYGBf13FyQuiTwlAQgxVSNgt4="
  crossorigin="anonymous"></script>

    <!-- Tether, needed by Bootstrap 4 -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/tether/1.4.0/js/tether.min.js" integrity="sha384-DztdAPBWPRXSA/3eYEEUWrWCy7G5KFbe8fFjk5JAIxUYHKkDx6Qin1DkWx51bBrb" crossorigin="anonymous"></script>

    <!-- Bootstrap 4 -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/css/bootstrap.min.css" integrity="sha384-rwoIResjU2yc3z8GV/NPeZWAv56rSmLldC3R/AZzGRnGxQQKnKkoFVhFQhNUwEyJ" crossorigin="anonymous">
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/js/bootstrap.min.js" integrity="sha384-vBWWzlZJ8ea9aCX4pEW3rVHjgjt7zpkNpZk+02D9phzyeVkE+jo0ieGizqPLForn" crossorigin="anonymous"></script>

    <asset:stylesheet src="font-awesome.min.css"/>
    <asset:stylesheet src="notes.css"/>

    <g:layoutHead/>

    <style>
    nav > div {
      margin: 0
    }
    .navbar {
      background-color: #8274C1; /* lavender dark */
      padding:  10px 15px 0 15px;
      margin: 0;
    }
    .navbar-brand {
      color: #fff;
      font-size: 1.4em;
    }
    .navbar-toggler {
      color: #fff;
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
    .navbar .top {
      padding-bottom: 10px;
    }
    main {
      padding: 10px;
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
        display: inline-block;
      }
    }
    /* medium or above */
    @media (min-width : 768px) {
      #menu {
        display: block;
      }
      html, body, .container-fluid, .container-fluid > .row {
        height: 100%; /* menu 100% vertical on big screens */
      }
    }

    /* button material */
    .btn {
      font-size: .8rem;
      padding: .85rem 2.13rem;
      border-radius: 2px;
      border: 0;
      -webkit-transition: .2s ease-out;
      transition: .2s ease-out;
      color: #fff!important;
      margin: 6px;
      white-space: normal!important;
      word-wrap: break-word;
      text-transform: uppercase;

      -webkit-box-shadow: 0 2px 5px 0 rgba(0,0,0,.16),0 2px 10px 0 rgba(0,0,0,.12);
      box-shadow: 0 2px 5px 0 rgba(0,0,0,.16),0 2px 10px 0 rgba(0,0,0,.12);
      display: inline-block;
      line-height: 1.25;
      text-align: center;
      vertical-align: middle;
      user-select: none;
    }
    .btn:focus,.btn:hover {
      text-decoration: none
    }

    .btn-primary {
      background-color: #9B8FCD;
    }
    .btn-primary:hover {
       background-color: #8274C1;
    }
    .btn-primary.focus,.btn-primary:focus {
      -webkit-box-shadow: 0 2px 5px 0 rgba(0,0,0,.16),0 2px 10px 0 rgba(0,0,0,.12);
      box-shadow: 0 2px 5px 0 rgba(0,0,0,.16),0 2px 10px 0 rgba(0,0,0,.12);
    }
    .btn-primary.disabled,.btn-primary:disabled {
       border-color: #ccc;
    }
    
    .btn-secondary {
      background-color: #a0d468;
    }
    .btn-secondary:hover {
       background-color: #8cc152;
    }


    /* Buttons calendar
------------------------------------------------------------------------*/
button.fc-button {
  /*font-family: 'Roboto', sans-serif;*/
  border-color: #9675ce;
  color: #9675ce;
}
button.fc-button:active, button.fc-button:focus {
  outline: none !important; /* removes blue outline when calendar header buttons are clicked */
}
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
    </style>
  </head>
  <body>
    <div class="container-fluid">
      <div class="row">
        <nav class="navbar col-md-2 col-sm-12">
          <div class="row top">
            <div class="col-12">
              <a class="navbar-brand" href="#">
               <!-- <img src="https://v4-alpha.getbootstrap.com/assets/brand/bootstrap-solid.svg" width="30" height="30" class="d-inline-block align-middle" alt="" />-->
                Notes
              </a>
              <button class="navbar-toggler navbar-toggler-right collapse" type="button" data-toggle="collapse" data-target="#menu"><i class="fa fa-bars" aria-hidden="true"></i></button>
            </div>
          </div><!-- top -->
          <div class="row navbar-collapse" id="menu">
            <div class="col-12">
              <ul class="navbar-nav flex-column">
                <li class="nav-item">
                  <a class="nav-link ${(controllerName=='dashboard')?'active':''}" href="#"><i class="fa fa-tachometer fa-fw" aria-hidden="true"></i> Overview</a>
                </li>
                <li class="nav-item">
                  <g:link controller="patient" action="index" class="nav-link ${(controllerName=='patient')?'active':''}"><i class="fa fa-user-circle-o fa-fw" aria-hidden="true"></i> Patients</g:link>
                </li>
                <li class="nav-item">
                  <g:link controller="timeSlot" action="index" class="nav-link ${(controllerName=='timeSlot')?'active':''}"><i class="fa fa-calendar fa-fw" aria-hidden="true"></i> Agenda</g:link>
                </li>
                <li class="nav-item">
                  <g:link controller="logout" class="nav-link"><i class="fa fa-sign-out fa-fw" aria-hidden="true"></i> Logout</g:link>
                </li>
              </ul>
            </div>
          </div><!-- menu -->
        </nav>
        <main class="col-md-10 col-sm-12">
          <g:layoutBody/>
        </main>
      </div>
    </div>
  </body>
</html>
