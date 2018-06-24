package com.cabolabs.notes

import com.cabolabs.security.User

class Plan {

   String id
   String name
   Integer maxPatients
   Integer maxNotesPerMonth

   static constraints = {
   }

   static mapping = {
      id generator:'uuid2'
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

   def associateTo(User user)
   {
      // TODO: check current plan and unassing it (ends now), this is done on UserController.update
      def assoc = new PlanAssociation(plan: this, user: user, validFrom: new Date(), validTo: new Date() + 365)
      assoc.save(failOnError: true)
   }
}
