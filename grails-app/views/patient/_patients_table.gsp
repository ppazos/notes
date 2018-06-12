<g:if test="${!patientList}">
  <div class="zero-state-container">
    <h1 class="zero-state"><g:message code="patient.index.zero_state"/></h1>
  </div>
</g:if>

<table class="table">
  <thead>
    <tr>
      <th><g:message code="patient.attr.firstname"/></th>
      <th><g:message code="patient.attr.lastname"/></th>
      <th class="d-none d-md-table-cell d-xl-table-cell"><g:message code="patient.attr.dob"/></th>
      <th class="d-none d-md-table-cell d-xl-table-cell"><g:message code="patient.attr.sex"/></th>
      <th><g:message code="patient.attr.notes"/></th>
    </tr>
  </thead>
  <tbody>
    <g:each in="${patientList}" var="p">
      <tr>
        <td>${p.name}</td>
        <td>${p.lastname}</td>
        <td class="d-none d-md-table-cell d-xl-table-cell"><g:formatDate date="${p.dob}" type="date" style="MEDIUM"/></td>
        <td class="d-none d-md-table-cell d-xl-table-cell">${p.sex}</td>
        <td><g:link controller="note" action="index" params="[pid: p.id]"><i class="fa fa-file-text-o" aria-hidden="true" style="font-size: 1.4em;"></i></g:link></td>
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
