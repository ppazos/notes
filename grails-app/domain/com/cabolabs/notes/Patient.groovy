package com.cabolabs.notes

import com.cabolabs.security.User

class Patient {

   String uid = java.util.UUID.randomUUID() as String
   String name
   String lastname
   String phone
   String email
   String sex
   Date dob
   
   User owner

   static constraints = {
      email(nullable:true)
      phone(nullable:true)
   }
}
