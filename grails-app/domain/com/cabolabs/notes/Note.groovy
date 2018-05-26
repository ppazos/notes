package com.cabolabs.notes

import com.cabolabs.security.User

class Note {

   Date dateCreated
   String color
   String text

   User author
   Patient patient
   NoteCategory category

   int month // not mapped to the database, formula to do calculations

   static constraints = {
      text maxSize: 4096
      color inList: ['success', 'info', 'warning', 'danger', 'primary', 'secondary']
      category nullable: true
   }

   static mapping = {
      month formula: 'MONTH(date_created)' // WARN: MySQL MONTH starts on 1
   }

   static namedQueries = {
      inCurrentMonth { author ->
         def now = new Date()
         eq('author', author)
         eq('month', now.month+1) // Java month starts on 0
      }
   }
}
