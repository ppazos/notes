package com.cabolabs.notes

class CommitJob {
    static triggers = {
      simple repeatInterval: 5000l // execute job once in 5 seconds
    }

    def execute()
    {
       println "job"
        // execute job
        String PS = System.getProperty("file.separator")
        def outbox = new File("documents" +PS+ "pending")
        outbox.eachFile { f ->
           println "File to commit "+ f.name
        }
    }
}
