<g:feedbackAlert clean="true" />

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
          <button type="button" class="btn btn-primary btn-small btn-edit" data-toggle="modal" data-id="${u.id}"><i class="fa fa-pencil" aria-hidden="true"></i></button>
          <g:if test="${!u.enabled}">
            <g:link url="[action: 'remind', id: u.id]" class="remind"><button type="button" class="btn btn-primary btn-small"><g:message code="user.action.remind" /></button></g:link>
          </g:if>
        </td>
      </tr>
    </g:each>
  </tbody>
</table>

<g:if test="${userList.totalCount > params.max}">
  <div class="pagination">
    <g:paginate total="${userList.totalCount}" />
  </div>
</g:if>

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
     * Edit/Update
     */
    $('.btn-edit').on('click', function(){

      set_action_update();

      _user_id = $(this).data('id');

      console.log(_user_id);

      $.ajax({
        type: "GET",
        url: "${createLink(controller:'user', action:'show')}",
        data: {id: _user_id},
        success: function(data, statusText, response)
        {
          console.log(data);
          if (!data.error) // true: can create notes
          {
            _form = $("#create_form");
            console.log(_form[0].action);

            $('input[name=id]').val(_user_id);

            $('#create_modal').modal('show');

            // populate user data
            $.each(data, function( field, value ) {
              _fld = $('[name='+field+']');
              if (_fld.length == 1) // single field with name
                $('[name='+field+']').val(value);
              else // radio button broup
                $('[name='+field+'][value='+value+']').prop('checked', true);
            });

            $('input[name=_current_plan]').val(data.plan);
          }
          else
          {
            $('main .row > .col:first').append('<div class="alert alert-custom fade in alert-dismissable show"><button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true" style="font-size:20px">&times;</span></button>'+ data.message +'</div>');
          }
        }
      });
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
