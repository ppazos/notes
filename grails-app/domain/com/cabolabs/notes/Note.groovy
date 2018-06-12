package com.cabolabs.notes

import com.cabolabs.security.User

class Note {

   String id
   Date dateCreated
   String color
   String text

   User author
   Patient patient
   NoteCategory category

   int month // not mapped to the database, formula to do calculations

   // https://anycount.com/WordCountBlog/how-many-words-in-one-page/
   static int maxNoteLength = 20000

   static constraints = {
      text maxSize: 20000 // this is about 5 pages long with 4000 characters per page, so 5 pages is the max note length
      color inList: ['success', 'info', 'warning', 'danger', 'primary', 'secondary']
      category nullable: true
   }

   static mapping = {
      id generator:'uuid2'
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
