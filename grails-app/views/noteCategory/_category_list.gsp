<table class="table">
  <thead>
    <tr>
      <th>Name</th>
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

<div class="pagination">
  <g:paginate total="${noteCategoryCount ?: 0}" />
</div>