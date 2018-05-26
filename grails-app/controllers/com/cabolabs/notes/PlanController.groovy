package com.cabolabs.notes

import grails.transaction.Transactional
import grails.converters.JSON

@Transactional(readOnly = true)
class PlanController {

   def springSecurityService

   /**
    * checks the plan to see if a new note can be created.
    */
   def canCreateNote()
   {
      def loggedInUser = springSecurityService.currentUser
      def planAssoc = Plan.associatedNow(loggedInUser)
      if (!planAssoc)
      {
         render text: [result: false, message: message(code:'plan.notActive')] as JSON, status: 404, contentType: "application/json"
         return
      }

      def maxNotesPerMonth = planAssoc.plan.maxNotesPerMonth
      if (Note.inCurrentMonth(loggedInUser).count() < maxNotesPerMonth)
      {
         render text: [result: true, message: message(code:'plan.notesCanBeCreated')] as JSON, status: 200, contentType: "application/json"
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
      def planAssoc = Plan.associatedNow(loggedInUser)
      if (!planAssoc)
      {
         render text: [result: false, message: message(code:'plan.notActive')] as JSON, status: 404, contentType: "application/json"
         return
      }

      def maxNotesPerMonth = planAssoc.plan.maxPatients
      if (Patient.countByOwner(loggedInUser) < maxNotesPerMonth)
      {
         render text: [result: true, message: message(code:'plan.patientsCanBeCreated')] as JSON, status: 200, contentType: "application/json"
         return
      }

      // max reached
      render text: [result: false, message: message(code:'plan.patientsCantBeCreated')] as JSON, status: 200, contentType: "application/json"
      return
   }
}
