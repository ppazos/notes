package com.cabolabs.notes

import com.cabolabs.security.User

class Payment {

   // this should be session.scheduledFor, to remove this we should warantee the slot cant be changed if its in the past (scheduledFor should not be removed)
   Patient patient
   TimeSlot session // scheduled session for the patient
   BigDecimal amount // amount paid
   Date paidOn // might be different that the date when the payment was recorded on the system

   User owner // user owning this payment

   Date dateCreated

   static constraints = {
      paidOn nullable: true
   }
}
