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
    </style>

  </head>
  <body>
    <div class="container-fluid">
      <div class="row">
        <nav class="navbar col-md-3 col-sm-12">
          <div class="row top">
            <div class="col-12">
              <a class="navbar-brand" href="#">
                <img src="https://v4-alpha.getbootstrap.com/assets/brand/bootstrap-solid.svg" width="30" height="30" class="d-inline-block align-middle" alt="" />
                Notes
              </a>
              <button class="navbar-toggler navbar-toggler-right collapse" type="button" data-toggle="collapse" data-target="#menu">&#9776;</button>
            </div>
          </div><!-- top -->
          <div class="row navbar-collapse" id="menu">
            <div class="col-12">
              <ul class="navbar-nav flex-column">
                <li class="nav-item">
                  <a class="nav-link ${(controllerName=='dashboard')?'active':''}" href="#"><i class="fa fa-tachometer fa-fw" aria-hidden="true"></i>
Overview</a>
                </li>
                <li class="nav-item">
                  <g:link controller="patient" action="index" class="nav-link ${(controllerName=='patient')?'active':''}"><i class="fa fa-user-circle-o fa-fw" aria-hidden="true"></i> Patients</g:link>
                </li>
                <li class="nav-item">
                  <a class="nav-link ${(controllerName=='agenda')?'active':''}" href="#"><i class="fa fa-calendar fa-fw" aria-hidden="true"></i>
 Agenda</a>
                </li>
                <li class="nav-item">
                  <g:link controller="logout" class="nav-link"><i class="fa fa-sign-out fa-fw" aria-hidden="true"></i>
 Logout</g:link>
                </li>
              </ul>
            </div>
          </div><!-- menu -->
        </nav>
        <main class="col-md-9 col-sm-12">
          <g:layoutBody/>
        </main>
      </div>
    </div>
  </body>
</html>
