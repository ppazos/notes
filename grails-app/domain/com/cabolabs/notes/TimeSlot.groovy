package com.cabolabs.notes

class TimeSlot {

   String uid = java.util.UUID.randomUUID() as String
   
   String name
   String color
   Date start
   Date end

   String status = 'open'
   Date scheduledOn // when status changes to scheduled, records that moment

   static constraints = {
      status(inList: ['open','scheduled'])
      scheduledOn(nullable: true)
   }
}
