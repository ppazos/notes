package com.cabolabs.security

import com.cabolabs.notes.*

class NotesSecurityInterceptor {

   def springSecurityService

   /*
   these actions depend on the pid being present,
   the patient for that pid to exist and be a
   patient of the current logged in user
   */
   public NotesSecurityInterceptor()
   {
      match controller: 'note', action: 'index'
      match controller: 'note', action: 'note_list'
      match controller: 'note', action: 'save'
   }

   boolean before()
   {
      def pid = params.pid

      if (!pid)
      {
         flash.message = 'note.index.error.noPatientId'
         redirect controller: 'patient'
         return false
      }

      // patient exists?
      def patient = Patient.get(pid)
      if (!patient)
      {
         flash.message = 'note.index.error.patientNotFound'
         redirect controller: 'patient'
         return false
      }

      // is my patient?
      // we don't say the patient exists!
      def loggedInUser = springSecurityService.currentUser
      if (patient.owner != loggedInUser)
      {
         flash.message = 'note.index.error.patientNotFound'
         redirect controller: 'patient'
         return false
      }

      params.patient = patient

      true
   }

   boolean after()
   {
      true
   }

   void afterView()
   {
      // no-op
   }
}
