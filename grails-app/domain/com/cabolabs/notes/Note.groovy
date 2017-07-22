package com.cabolabs.notes

import com.cabolabs.security.User

class Note {

   Date dateCreated
   String color
   String text

   User author
   Patient patient
   NoteCategory category

   static constraints = {
      text maxSize: 4096
      color inList: ['success', 'info', 'warning', 'danger', 'primary', 'secondary']
      category nullable: true
   }
}
