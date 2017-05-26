package com.cabolabs.notes

class Patient {

   String uid = java.util.UUID.randomUUID() as String
   String name
   String lastname
   String phone
   String email
   String sex
   Date dob
   
   static constraints = {
   }
}
