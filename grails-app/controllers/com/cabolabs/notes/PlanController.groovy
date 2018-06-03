package com.cabolabs.notes

import grails.transaction.Transactional
import grails.converters.JSON

@Transactional(readOnly = true)
class PlanController {

   def springSecurityService
   def planService

   /**
    * checks the plan to see if a new note can be created.
    */
   def canCreateNote()
   {
      def loggedInUser = springSecurityService.currentUser
      try
      {
         if (planService.canCreateNote(loggedInUser))
         {
            render text: [result: true, message: message(code:'plan.notesCanBeCreated')] as JSON, status: 200, contentType: "application/json"
            return
         }
      }
      catch (Exception e)
      {
         render text: [result: false, message: message(code:e.message)] as JSON, status: 404, contentType: "application/json"
         return
      }

      // max reached
      render text: [result: false, message: message(code:'plan.notesCantBeCreated')] as JSON, status: 200, contentType: "application/json"
      return
   }

   /**
    * checks the plan to see if a new patient can be added.
    */
   def canCreatePatient()
   {
      def loggedInUser = springSecurityService.currentUser
      try
      {
         if (planService.canCreatePatient(loggedInUser))
         {
            render text: [result: true, message: message(code:'plan.patientsCanBeCreated')] as JSON, status: 200, contentType: "application/json"
            return
         }
      }
      catch (Exception e)
      {
         render text: [result: false, message: message(code:e.message)] as JSON, status: 404, contentType: "application/json"
         return
      }

      // max reached
      render text: [result: false, message: message(code:'plan.patientsCantBeCreated')] as JSON, status: 200, contentType: "application/json"
      return
   }
}
