<table class="table">
  <thead>
    <tr>
      <th><g:message code="user.attr.username"/></th>
      <th><g:message code="user.attr.name"/></th>
      <th><g:message code="user.attr.lastname"/></th>
      <th><g:message code="user.attr.enabled"/></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <g:each in="${userList}" var="u">
      <tr>
        <td>${u.username}</td>
        <td>${u.name}</td>
        <td>${u.lastname}</td>
        <td>${u.enabled}</td>
        <td>
          <g:if test="${!u.enabled}">
            <g:link url="[action: 'remind', id: u.id]" class="remind"><button type="button" class="btn btn-primary btn-small"><g:message code="user.action.remind" /></button></g:link>
          </g:if>
        </td>
      </tr>
    </g:each>
  </tbody>
</table>

<div class="pagination">
  <g:paginate total="${userList.totalCount}" />
</div>

<script>
  $(document).ready(function() {

    /*
     * AJAX Pagination
     */
    $('.pagination > a').on('click', function(e) {
      $.ajax({
        type: "GET",
        url: $(this).attr('href'),
        success: function(data, statusText, response)
        {
          $('#table').html(data);
        }
      });
      e.preventDefault();
    });

    /*
     * Remind AJAX
     */
    $('.remind').on('click', function(e){

      e.preventDefault();

      var _lnk = $(this);

      // click after a click was done and didnt finished the work yet
      if (_lnk.hasClass('disabled')) return false;

      // prevents double click
      _lnk.addClass('disabled');
      var _btn = $('.btn', this);
      _btn.addClass('disabled');

      $.ajax({
        type: "POST",
        url: this.href,
        data: $("#create_form").serialize(),
        success: function(data, statusText, response)
        {
          if (!data.error)
          {
            $('main .row > .col:first').append('<div class="alert alert-custom fade in alert-dismissable show"><button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true" style="font-size:20px">&times;</span></button>'+ data.message +'</div>');
          }
        },
        error: function(response, statusText)
        {
          error = JSON.parse(response.responseText);
          if (error.error)
          {
            $('main .row > .col:first').append('<div class="alert alert-custom fade in alert-dismissable show"><button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true" style="font-size:20px">&times;</span></button>'+ error.message +'</div>');
          }
        }
      })
      .then(function(){
        console.log('done', _btn);
        _lnk.removeClass('disabled');
        _btn.removeClass('disabled');
      });
    });
  });
</script>
