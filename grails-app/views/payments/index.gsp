<!DOCTYPE html>
<html>
  <head>
    <meta name="layout" content="notes-internal" />
    <title><g:message code="payments.index.title" /></title>
    <style type="text/css">

    </style>
  </head>
  <body>
    <div class="row">
      <div class="col">
        <h1><g:message code="payments.index.title" /></h1>
      </div>
    </div>

    <g:if test="${flash.message}">
      <div class="row">
        <div class="col">
          <div class="message" role="status">${flash.message}</div>
        </div>
      </div>
    </g:if>

    <div class="row">
      <div class="col-sm-6">
        <h2>not paid</h2>
        <g:each in="${pastSlotsNotPaid}" var="slot">
          <div class="card">
            <div class="card-header" style="background-color: ${slot.color}">
              <div class="row">
                <div class="col-6">
                  <!--<i class="fa fa-dollar fa-dash" aria-hidden="true"></i>-->
                </div>
                <div class="col-6 text-right">
                  <div>${slot.scheduledFor.name} ${slot.scheduledFor.lastname}</div>
                  <div>${slot.start}</div>
                </div>
              </div>
            </div>
          </div>
        </g:each>
      </div>
      <div class="col-sm-6">
        <h2>paid</h2>
        <g:each in="${pastSlotsPaid}" var="slot">
          ${slot.start}
        </g:each>
      </div>
    </div>
    <script>
    $('.card-header').each(function(){
      //console.log(this.style.backgroundColor, shadeRGBColor(this.style.backgroundColor, -0.2));

      // darken the border of the card depending on the background color
      this.parentNode.style.borderColor = shadeRGBColor(this.style.backgroundColor, -0.2);
    });

    function shadeHEXColor(color, percent) {
      var f=parseInt(color.slice(1),16),t=percent<0?0:255,p=percent<0?percent*-1:percent,R=f>>16,G=f>>8&0x00FF,B=f&0x0000FF;
      return "#"+(0x1000000+(Math.round((t-R)*p)+R)*0x10000+(Math.round((t-G)*p)+G)*0x100+(Math.round((t-B)*p)+B)).toString(16).slice(1);
    }
    function shadeRGBColor(color, percent) {
      var f=color.split(","),t=percent<0?0:255,p=percent<0?percent*-1:percent,R=parseInt(f[0].slice(4)),G=parseInt(f[1]),B=parseInt(f[2]);
      return "rgb("+(Math.round((t-R)*p)+R)+","+(Math.round((t-G)*p)+G)+","+(Math.round((t-B)*p)+B)+")";
    }
    </script>

  </body>
</html>
