package com.cabolabs.notes

import com.cabolabs.ehrserver.* // groovy client
import grails.core.GrailsApplication

class CommitJob {

   GrailsApplication grailsApplication

   static triggers = {
      simple repeatInterval: 60000l // execute job once in 60 seconds
   }

   def execute()
   {
      def protocol = grailsApplication.config.getProperty('ehrserver.protocol')
      def ip       = grailsApplication.config.getProperty('ehrserver.ip')
      def port     = grailsApplication.config.getProperty('ehrserver.port', Integer)
      def path     = grailsApplication.config.getProperty('ehrserver.path')

      println 'server '+ protocol+ ip +':'+ port + path

      //println "job"
       // execute job
      String PS  = System.getProperty("file.separator")
      def outbox = new File("documents" +PS+ "pending") // TODO define absolute path prefix as ENV
      def sent   = new File("documents" +PS+ "sent")
      def f

      def pending = Commit.findAllByStatus("pending")
      pending.each { commit ->

         // commit, the file already has the versions envelope
         def ehrserver = new EhrServerClient(protocol, ip, port, path)
         ehrserver.login('admin', 'pablopablo', '123456')

         // TODO: get EHR using the patient uid from EHRServer
         // TODO: use the user as committer, might need to save the document creation log into the database
         try {

           f = new File(commit.filepath)

           //def res = ehrserver.commit('11111111-1111-1111-1111-111111111111', f.text, 'Dr. House', 'Notes')
           def res = ehrserver.commit(commit.note.patient.ehrUid,
                                      f.text,
                                      commit.note.author.name+" "+commit.note.author.lastname,
                                      'Notes')

           if (res)
           {
             if (res.status in 200..299)
             {
                println res
               //assert res != null
               //assert res.type.text() == 'AA'
               println res.message

               // move
               //f.renameTo(new File(sent, f.name))
               commit.status = "completed"
               commit.save(flush: true)
             }
             else
             {
               println "An error ocurred on commit "+ res.status +" "+ res.message
             }
           }
           else {
             println "An error ocurred on commit, please check the EHR exists"
           }
         }
         catch (e)
         {
           println "An error ocurred on commit "+ e.message
         }
      }

      /*
      outbox.eachFile { f ->

         if (!f.name.endsWith('.xml')) return

         println "File to commit "+ f.name 

         // commit, the file already has the versions envelope
         def ehrserver = new EhrServerClient(protocol, ip, port, path)
         ehrserver.login('admin', 'pablopablo', '123456')

         // TODO: get EHR using the patient uid from EHRServer
         // TODO: use the user as committer, might need to save the document creation log into the database
         try {
           //def res = ehrserver.commit('11111111-1111-1111-1111-111111111111', f.text, 'Dr. House', 'Notes')
           def res = ehrserver.commit('4f998a17-8731-4341-afed-3d5861287d41', f.text, 'Dr. House', 'Notes')

           if (res)
           {
             assert res != null
             assert res.type.text() == 'AA'

             // move
             f.renameTo(new File(sent, f.name))
           }
           else {
             println "An error ocurred on commit, please check the EHR exists"
           }
         }
         catch (e)
         {
           println "An error ocurred on commit "+ e.message
         }

      }
      */

   }
}
