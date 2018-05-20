package com.cabolabs.notes

import com.cabolabs.security.User

class TimeSlot {

   User owner

   String uid = java.util.UUID.randomUUID() as String

   String name
   String color
   Date start
   Date end

   String status = 'open'
   Date scheduledOn // when status changes to scheduled, records that moment
   Patient scheduledFor

   // paid marker to simplify querying
   boolean paid = false

   static transients = ['durationInMinutes', 'payment']

   def getDurationInMinutes()
   {
      groovy.time.TimeCategory.minus(this.end, this.start).toMilliseconds() / 1000 / 60
   }
   def getPayment()
   {
      Payment.findBySession(this)
   }

   static constraints = {
      status(inList: ['open','scheduled'])
      scheduledOn(nullable: true)
      scheduledFor(nullable: true)
   }

   static mapping = {
     start column: 'slot_start' // reserved on previous versions of postgres
     end column: 'slot_end' // reserved for postgres
   }

   static namedQueries = {
      pastScheduled { owner ->
         eq('owner', owner)
         lt('end', new Date())
         isNotNull('scheduledFor') // is scheduled for a patient
      }
      isPaid {
         eq('paid', true)
      }
      isUnpaid {
         eq('paid', false)
      }
   }
}
