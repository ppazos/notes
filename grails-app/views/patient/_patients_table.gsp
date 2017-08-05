<table class="table">
  <thead>
    <tr>
      <th><g:message code="patient.attr.firstname"/></th>
      <th><g:message code="patient.attr.lastname"/></th>
      <th><g:message code="patient.attr.dob"/></th>
      <th><g:message code="patient.attr.sex"/></th>
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