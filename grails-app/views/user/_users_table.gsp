<table class="table">
  <thead>
    <tr>
      <th><g:message code="user.attr.username"/></th>
      <th><g:message code="user.attr.name"/></th>
      <th><g:message code="user.attr.lastname"/></th>
      <th><g:message code="user.attr.enabled"/></th>
    </tr>
  </thead>
  <tbody>
    <g:each in="${userList}" var="u">
      <tr>
        <td>${u.username}</td>
        <td>${u.name}</td>
        <td>${u.lastname}</td>
        <td>${u.enabled}</td>
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
  });
</script>