package com.cabolabs.notes

import com.cabolabs.ehrserver.* // groovy client

class CommitJob {
   static triggers = {
      simple repeatInterval: 60000l // execute job once in 60 seconds
   }

   def execute()
   {
      //println "job"
       // execute job
      String PS  = System.getProperty("file.separator")
      def outbox = new File("documents" +PS+ "pending")
      def sent   = new File("documents" +PS+ "sent")

      outbox.eachFile { f ->

         println "File to commit "+ f.name
         
         // commit, the file already has the versions envelope
         def ehrserver = new EhrServerClient('http://', '192.168.1.108', 8090, '/ehr/')
         ehrserver.login('user', 'user', '123456')

         // TODO: get EHR using the patient uid from EHRServer
         // TODO: use the user as committer, might need to save the document creation log into the database
         def res = ehrserver.commit('11111111-1111-1111-1111-111111111111', f.text, 'Dr. House', 'Notes')

         assert res != null
         assert res.type.text() == 'AA'

         // move
         f.renameTo(new File(sent, f.name))
      }
   }
}
