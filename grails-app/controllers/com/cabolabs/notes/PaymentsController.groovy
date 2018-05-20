package com.cabolabs.notes

import grails.transaction.Transactional
import grails.converters.JSON

@Transactional(readOnly = true)
class PaymentsController {

   def springSecurityService

   def index()
   {
      /*
      def loggedInUser = springSecurityService.currentUser
      def pastSlotsPaid = TimeSlot.pastScheduled(loggedInUser).isPaid.list()
      def pastSlotsNotPaid = TimeSlot.pastScheduled(loggedInUser).isUnpaid.list()
      return [pastSlotsNotPaid: pastSlotsNotPaid, pastSlotsPaid: pastSlotsPaid]
      */
   }

   /*
    * id timeslot.id
    * amount payment.amount
    * paidOn payment.paidOn date
    */
   @Transactional
   def save(Long id)
   {
      println params
      if (!id)
      {

      }
      if (!params.amount)
      {

      }

      def loggedInUser = springSecurityService.currentUser
      def slot = TimeSlot.get(id)
      def payment = new Payment(params)
      payment.owner = loggedInUser
      payment.session = slot
      payment.patient = slot.scheduledFor

      if (!payment.save(flush: true))
      {
         render payment.errors.fieldErrors as JSON, status: 400, contentType: "application/json"
         return
      }

      slot.paid = true
      if (!slot.save(flush: true))
      {
         // TODO HANDLE
      }

      redirect action:'index_body_partial'
   }

   def index_body_partial()
   {
      println actionName
      def loggedInUser = springSecurityService.currentUser
      def pastSlotsPaid = TimeSlot.pastScheduled(loggedInUser).isPaid.list()
      def pastSlotsNotPaid = TimeSlot.pastScheduled(loggedInUser).isUnpaid.list()
      render(template: "index_body_partial", model: [pastSlotsNotPaid: pastSlotsNotPaid, pastSlotsPaid: pastSlotsPaid])
   }
}
