package com.cabolabs.notes

class Commit {

   Date dateCreated
   Note note
   String status = "pending"
   String filepath // generated composition from note to commit

   static constraints = {
   	  status(inList:["pending", "completed"])
   }
}
