package com.cabolabs.notes

import grails.transaction.Transactional
import com.cabolabs.security.User
import com.cabolabs.exceptions.UserDoesntHaveAPlanException

@Transactional
class PlanService {

   boolean canCreateNote(User user)
   {
      def planAssoc = Plan.associatedNow(user)
      if (!planAssoc)
      {
         throw new UserDoesntHaveAPlanException(user, 'plan.notActive')
      }

      def maxNotesPerMonth = planAssoc.plan.maxNotesPerMonth
      if (Note.inCurrentMonth(user).count() < maxNotesPerMonth)
      {
         return true
      }

      return false
   }

   boolean canCreatePatient(User user)
   {
      def planAssoc = Plan.associatedNow(user)
      if (!planAssoc)
      {
         throw new UserDoesntHaveAPlanException(user, 'plan.notActive')
      }

      def maxNotesPerMonth = planAssoc.plan.maxPatients
      if (Patient.countByOwner(user) < maxNotesPerMonth)
      {
         return true
      }

      return false
   }
}
