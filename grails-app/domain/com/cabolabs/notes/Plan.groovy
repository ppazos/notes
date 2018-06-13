package com.cabolabs.notes

import com.cabolabs.security.User

class Plan {

   String name
   Integer maxPatients
   Integer maxNotesPerMonth

   static constraints = {
   }

   static PlanAssociation associatedNow(User user)
   {
      return associatedOn(user, new Date())
   }

   static PlanAssociation associatedOn(User user, Date on)
   {
      def pa = PlanAssociation.withCriteria(uniqueResult: true) {
        le('validFrom', on) // from <= on < to
        gt('validTo', on)
        eq('user', user)
      }

      return pa // can be null
   }
}