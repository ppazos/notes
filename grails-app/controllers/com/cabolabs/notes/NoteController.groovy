package com.cabolabs.notes

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import java.text.SimpleDateFormat
import grails.converters.JSON

import com.cabolabs.security.*
import javax.servlet.http.Cookie

@Transactional(readOnly = true)
class NoteController {

   static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

   def springSecurityService
   def ehrServerService
   def planService

   def index(Integer max, String categoryName, boolean uncategorized, String columns)
   {
      // added by interceptor
      def patient = params.patient
      def loggedInUser = springSecurityService.currentUser

      // without this, if the param columns is sent from the client the first time
      // the view is displayed, it is ignored on note_list to set the cookie.
      // sets the cookie if a columns value comes from client
      if (columns)
      {
         def cook = new Cookie('cols', columns)
         cook.path = '/'
         cook.maxAge = 999999
         response.addCookie(cook)
      }
      else // if cookie doesnt exists, set default to 2 cols
      {
         def cook = request.cookies.find{ it.name == 'cols' }
         if (!cook)
         {
            columns = '2'
            cook = new Cookie('cols', columns)
            cook.path = '/'
            cook.maxAge = 999999
            response.addCookie(cook)
         }
      }

      def categories = NoteCategory.findAllByOwner(loggedInUser)
      [categories: categories, patient: patient, layout: columns as Integer]
   }

   def note_list(Integer max, String categoryName, boolean uncategorized, String columns)
   {
      //println 'note_list params: '+ params

      // want to remember how the user wanted to see the notes, so we use cookies
      //request.cookies.each{ println '- '+ it.name +' '+ it.value +' '+ it.path }
      def cook
      if (!columns)
      {
         cook = request.cookies.find{ it.name == 'cols' }
         if (cook) // Get from cookie
         {
            columns = cook.value
         }
      }
      else // overwrite if value comes from ajax
      {
         cook = new Cookie('cols', columns)
         cook.path = '/'
         cook.maxAge = 9999
         response.addCookie(cook)
      }


      // TODO: patient exists?
      // TODO: is my patient?

      params.max = Math.min(max ?: 9, 100)
      if (!params.offset) params.offset = 0
      params.sort = "dateCreated"
      params.order = "desc"

      // added by interceptor
      def patient = params.patient
      def loggedInUser = springSecurityService.currentUser
      def categories = NoteCategory.findAllByOwner(loggedInUser)

      // Default category to list notes, can be null and show no category notes
      def category = categories[0]

      if (categoryName)
      {
         category = categories.find {it.name == categoryName}
      }

      if (uncategorized)
      {
         category = null
      }

      def c = Note.createCriteria()
      def noteList = c.list(params) {
         eq('patient', patient)
         if (category)
         {
             eq('category', category)
         }
         else
         {
             isNull('category')
         }
      }

      render template: 'note_list',
            model:[
              noteList:   noteList,
              patient:    patient,
              categories: categories,
              category:   category,
              layout: columns as Integer
            ]
   }

   def show(Note note) {
      respond note
   }

   def create() {
      respond new Note(params)
   }

   @Transactional
   def save(Note note)
   {
      println "save "+ params

      if (note == null)
      {
         transactionStatus.setRollbackOnly()
         notFound()
         return
      }

      def loggedInUser = springSecurityService.currentUser

      try
      {
         if (!planService.canCreateNote(loggedInUser))
         {
            render text: [result: false, message: message(code:'plan.notesCantBeCreated')] as JSON, status: 400, contentType: "application/json"
            return
         }
      }
      catch (Exception e)
      {
         render text: [result: false, message: message(code:e.message)] as JSON, status: 404, contentType: "application/json"
         return
      }

      // added by interceptor
      def patient = params.patient

// TODO: note text is required, validate + error report

      note.properties = params
      note.color = 'info' // TODO: set by user, is a tw bootstrap class
      note.author = loggedInUser //User.findByUsername(username)
      note.patient = patient
      note.validate()

      if (note.hasErrors())
      {
         println "note errors"
         //println note.errors
         //println note.errors.allErrors
         println note.errors.fieldErrors

         transactionStatus.setRollbackOnly()
         //respond note.errors, view:'index'
         //return

         // TODO: report error like patient save
         //redirect action: 'index', params: [pid: pid]
         render note.errors.fieldErrors as JSON, status: 400, contentType: "application/json"
         return
      }

      note.save flush:true

      ehrServerService.prepareCommit(note, loggedInUser)

/*
        // TODO: put this on a service

        // test file
        String PS = System.getProperty("file.separator")
        //def template_document = new File("openehr" +PS+ "Psychotherapy_Note_tags_envelope.xml")
        def template_document = new File("openehr" +PS+ "with_category" +PS+ "Psychotherapy_Note.EN.v1_tags_envelope.xml")
        def xml = template_document.text

        def datetime_format_openEHR = "yyyyMMdd'T'HHmmss,SSSZ"
        def format_oehr = new SimpleDateFormat(datetime_format_openEHR)
        def str_date_openEHR = format_oehr.format(new Date())
        println str_date_openEHR

        def note_text = note.text.replace('&', '&amp;')
        println note_text

        def data = [
          '[[CONTRIBUTION:::UUID:::ANY]]'          : java.util.UUID.randomUUID() as String,
          '[[COMMITTER_ID:::UUID:::ANY]]'          : loggedInUser.uid,
          '[[COMMITTER_NAME:::STRING:::Dr. House]]': loggedInUser.name+" "+loggedInUser.lastname,
          '[[TIME_COMMITTED:::DATETIME:::NOW]]'    : str_date_openEHR,
          '[[VERSION_ID:::VERSION_ID:::ANY]]'      : (java.util.UUID.randomUUID() as String) +'::PSY.NOTES::1',
          '[[COMPOSITION:::UUID:::ANY]]'           : java.util.UUID.randomUUID() as String,
          '[[COMPOSITION_DATE:::DATETIME:::NOW]]'  : str_date_openEHR,
          '[[Synopsis:::STRING:::]]'               : groovy.xml.XmlUtil.escapeXml(note_text),
          '[[Category.Name]]'                      : note.category.name,
          '[[Category.Code]]'                      : note.category.uid
        ]

        data.each { k, v ->
           println "$k : $v"
           xml = xml.replace(k, v) // reaplace all strings
        }
        //println xml

        // generate file to commit
        def out = new File("documents" +PS+ "pending" +PS+ data['[[COMPOSITION:::UUID:::ANY]]'] +".xml")
        out << xml
        //// test
*/

      redirect action: 'note_list', params: [categoryName: note.category?.name, pid: patient.id, uncategorized: (note.category == null)]
   }

   def edit(Note note)
   {
      respond note
   }

   @Transactional
   def update(Note note)
   {
      if (note == null)
      {
         transactionStatus.setRollbackOnly()
         notFound()
         return
      }

      if (note.hasErrors()) {
         transactionStatus.setRollbackOnly()
         respond note.errors, view:'edit'
         return
      }

      note.save flush:true

      request.withFormat {
         form multipartForm {
            flash.message = message(code: 'default.updated.message', args: [message(code: 'note.label', default: 'Note'), note.id])
            redirect note
         }
         '*'{ respond note, [status: OK] }
      }
   }

   @Transactional
   def delete(Note note)
   {
      if (note == null)
      {
         transactionStatus.setRollbackOnly()
         notFound()
         return
      }

      note.delete flush:true

      request.withFormat {
         form multipartForm {
            flash.message = message(code: 'default.deleted.message', args: [message(code: 'note.label', default: 'Note'), note.id])
            redirect action:"index", method:"GET"
         }
         '*'{ render status: NO_CONTENT }
      }
   }

   protected void notFound() {
      request.withFormat {
         form multipartForm {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'note.label', default: 'Note'), params.id])
            redirect action: "index", method: "GET"
         }
         '*'{ render status: NOT_FOUND }
      }
   }
}
