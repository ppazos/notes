<table class="table table-responsive">
  <thead>
    <tr>
      <th>First Name</th>
      <th>Last Name</th>
      <th>Dob</th>
      <th>Sex</th>
    </tr>
  </thead>
  <tbody>
    <g:each in="${patientList}" var="p">
      <tr>
        <td>
          <g:link controller="note" action="index" params="[pid: p.id]">${p.name}</g:link>
        </td>
        <td>${p.lastname}</td>
        <td>${p.dob}</td>
        <td>${p.sex}</td>
      </tr>
    </g:each>
  </tbody>
</table>

<div class="pagination">
  <g:paginate total="${patientList.totalCount}" />
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