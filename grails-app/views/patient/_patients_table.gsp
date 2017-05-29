<table class="table">
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