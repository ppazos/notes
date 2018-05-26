package com.cabolabs.notes

import com.cabolabs.security.User

class PlanAssociation {

   Date validFrom
   Date validTo
   Plan plan
   User user

   static constraints = {
   }
}
