package com.cabolabs.notes

import com.cabolabs.security.User

class Patient {

   String id
   String name
   String lastname
   String phone
   String email
   String sex
   Date dob

   String ehrUid

   User owner

   static constraints = {
      email(nullable:true)
      phone(nullable:true)
      ehrUid(nullable:true)
   }

   static mapping = {
      id generator:'uuid2'
   }
}
