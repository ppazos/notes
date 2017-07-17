package com.cabolabs.notes

class CommitJob {
   static triggers = {
      simple repeatInterval: 5000l // execute job once in 5 seconds
   }

   def execute()
   {
      println "job"
       // execute job
      String PS  = System.getProperty("file.separator")
      def outbox = new File("documents" +PS+ "pending")
      def sent   = new File("documents" +PS+ "sent")

      outbox.eachFile { f ->
         println "File to commit "+ f.name

         
         // TODO: commit, the file already has the versions envelope

         // move
         f.renameTo(new File(sent, f.name))
      }
   }
}
