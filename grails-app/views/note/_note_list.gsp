<%-- in: noteList, noteCount, categories, category (null if uncategorized) --%>
    <div class="row">
      <div class="col">
        <ul class="nav nav-tabs nav-fill flex-column flex-sm-row">
          <g:each in="${categories}" var="_category">
            <li class="nav-item">
              <a class="nav-link ${category?.name == _category.name ? 'active' : ''}" href="${createLink(action:'index', params:[categoryName:_category.name, pid: params.pid])}">${_category.name}</a>
            </li>
          </g:each>
          <li class="nav-item">
            <a class="nav-link ${category == null ? 'active' : ''}" href="${createLink(action:'index', params:[uncategorized: true, pid: params.pid])}">Uncategorized</a>
          </li>
        </ul>
      </div>
    </div>

    <div class="row">
      <div class="col">

       <g:if test="${!noteList}">
         <div class="zero-state-container">
           <h1 class="zero-state">Ups! we don't have any notes here.</h1>
         </div>
       </g:if>

        <%
        def cols = 2
        def list = noteList.collect() // new list
        def row = list.take(cols)
        %>
        <g:while test="${list}">
          <div class="card-deck"><!-- card-columns = masonry -->
            <g:each in="${row}" var="note">
              <div class="card">
                <div class="card-header">
                  ${note.id} ${note.dateCreated}
                </div>
                <div class="card-block">
                  <p class="card-text">
                    ${note.text.encodeAsRaw()}
                  </p>
                </div>
                <div class="card-footer card-${note.color}">
                </div>
              </div>
            </g:each>
          </div>
          <%
            list = list.drop(cols)
            row = list.take(cols)
          %>
        </g:while>

        <div class="pagination">
          <g:paginate total="${noteList.totalCount ?: 0}" />
        </div>
      </div>
    </div>