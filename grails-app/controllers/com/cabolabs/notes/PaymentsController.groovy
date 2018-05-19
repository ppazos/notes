package com.cabolabs.notes

class PaymentsController {

   def springSecurityService

   def index()
   {
      def loggedInUser = springSecurityService.currentUser
      def pastSlotsPaid = TimeSlot.pastScheduled(loggedInUser).isPaid.list()
      def pastSlotsNotPaid = TimeSlot.pastScheduled(loggedInUser).isUnpaid.list()

      /*
      def tmsc = TimeSlot.createCriteria()
      def pastSlotsNotPaid = tmsc.list {
         eq('owner', loggedInUser)
         lt('end', new Date())
         eq('paid', false)
         isNotNull('scheduledFor') // is scheduled for a patient
      }
      def pastSlotsPaid = tmsc.list { // TODO: pagination for these
         eq('owner', loggedInUser)
         lt('end', new Date())
         eq('paid', true)
         isNotNull('scheduledFor') // is scheduled for a patient
      }
      */

      return [pastSlotsNotPaid: pastSlotsNotPaid, pastSlotsPaid: pastSlotsPaid]
   }
}
