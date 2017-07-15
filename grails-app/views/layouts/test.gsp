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
    <!--<meta name="viewport" content="width=device-width, initial-scale=1"/>-->

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

    <asset:stylesheet src="application.css"/>

    <g:layoutHead/>

    <style>
      nav > div {
      margin: 0
    }
    .navbar {
      background-color: #8274C1;
      padding: .5rem 15px 0 15px;
      margin: 0;
    }
    .navbar-brand {
      color: #fff;
      font-size: 1.4em;
    }
    #menu {
      background-color: #9B8FCD;
    }
    #menu > div {
      padding: 0;
    }
    #menu li a {
      padding: 0.5rem 1rem;
      color: #fff;
    }
    #menu li a.active {
      border-left: 3px solid #fff;
    }
    .navbar .top {
      padding-bottom: .5rem;
    }
    main {
      padding: .5rem;
    }

    /* Small viewport or below */
    @media (max-width : 767px) {
      .navbar-toggler {
        display: inline;
        top: .5rem; /* adjust vertical position to middle top bar */
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
                <a class="nav-link active" href="#">Overview <span class="sr-only">(current)</span></a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="#">Reports</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="#">Analytics</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="#">Export</a>
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
