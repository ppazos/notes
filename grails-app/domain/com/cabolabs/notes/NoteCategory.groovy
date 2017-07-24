package com.cabolabs.notes

import com.cabolabs.security.User

class NoteCategory {

   String name
   User owner
   String uid = java.util.UUID.randomUUID() as String

   static constraints = {
   }
}
