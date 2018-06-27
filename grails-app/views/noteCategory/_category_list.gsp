<g:if test="${!noteCategoryList}">
  <div class="zero-state-container">
    <h1 class="zero-state"><g:message code="notecategory.index.zero_state"/></h1>
  </div>
</g:if>

<table class="table">
  <thead>
    <tr>
      <th><g:message code="notecategory.attr.name"/></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <g:each in="${noteCategoryList}" var="c">
      <tr>
        <td>${c.name}</td>
        <td></td>
      </tr>
    </g:each>
  </tbody>
</table>

<g:if test="${noteCategoryCount > params.max}">
  <div class="pagination">
    <g:paginate total="${noteCategoryCount ?: 0}" />
  </div>
</g:if>
