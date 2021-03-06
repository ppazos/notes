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
            <a class="nav-link ${category == null ? 'active' : ''}" href="${createLink(action:'index', params:[uncategorized: true, pid: params.pid])}"><g:message code="note.category.uncategorized"/></a>
          </li>
        </ul>
      </div>
    </div>

    <g:if test="${!noteList}">
    <div class="row">
      <div class="col">
          <div class="zero-state-container">
            <h1 class="zero-state"><g:message code="note.index.zero_state"/></h1>
          </div>
      </div>
    </div>
    </g:if>
    <g:else>

      <div class="row">
        <div class="col text-right notes-layout-selector">

          <button type="button" class="btn btn-primary btn-small notes-layout notes-layout-1 ${layout == 1 ? 'darker' : ''}">
            <span aria-hidden="true">&#124;</span>
          </button>
          <button type="button" class="btn btn-primary btn-small notes-layout notes-layout-2 ${layout == 2 ? 'darker' : ''}">
            <span aria-hidden="true">&#124;&#124;</span>
          </button>
          <button type="button" class="btn btn-primary btn-small notes-layout notes-layout-3 ${layout == 3 ? 'darker' : ''}">
            <span aria-hidden="true">&#124;&#124;&#124;</span>
          </button>
        </div>
      </div>

      <div class="row">
        <div class="col">

<%--
  <g:cookie name="cols" />
  <br /><br />
  ${layout}   ${layout.getClass()}
  <br /><br />
--%>
          <%
          def cols = layout
          def list = noteList.collect() // new list
          def row = list.take(cols)
          %>
          <g:while test="${list}">
            <div class="card-deck"><!-- card-columns = masonry -->
              <g:each in="${row}" var="note">
                <div class="card">
                  <div class="card-header">
                    <g:formatDate date="${note.dateCreated}" type="datetime" style="MEDIUM" timeZone="${session.tz}" />
                  </div>
                  <div class="card-body">
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

          <g:if test="${noteList.totalCount > params.max}">
            <div class="pagination">
              <g:paginate total="${noteList.totalCount ?: 0}" params="[pid: params.pid]" />
            </div>
          </g:if>
        </div>
      </div>
    </g:else>
