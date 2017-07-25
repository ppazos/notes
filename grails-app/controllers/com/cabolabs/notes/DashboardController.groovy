package com.cabolabs.notes

class DashboardController {

   def springSecurityService

   def index()
   {
      //def patients = Patient.coundBy... patiens are not associated with accounts yet!
      def loggedInUser = springSecurityService.currentUser

      def nc = Note.createCriteria()
      def notes = nc.count {
         patient {
            eq('owner', loggedInUser)
         }
      }

      return [patients: Patient.countByOwner(loggedInUser),
              slots:    TimeSlot.countByOwner(loggedInUser),
              notes:    notes]
   }
}
