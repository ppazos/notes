package com.cabolabs.notes

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import java.text.SimpleDateFormat

import com.cabolabs.security.*

@Transactional(readOnly = true)
class NoteController {

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def springSecurityService

    def index(Integer max, Long pid) {
        params.max = Math.min(max ?: 9, 100)
        params.sort = "id"
        params.order = "desc"
        
        def patient = Patient.get(pid)

        assert patient != null


        respond Note.findAllByPatient(patient, params), 
                model:[noteCount: Note.countByPatient(patient), patient: patient]
    }

    def show(Note note) {
        respond note
    }

    def create() {
        respond new Note(params)
    }

    @Transactional
    def save(Note note, Long pid) {

        println "save "+ params

        if (note == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }


        // TODO: put this on a service
        def loggedInUser = springSecurityService.currentUser

        // test file
        String PS = System.getProperty("file.separator")
        def template_document = new File("openehr" +PS+ "Psychotherapy_Note_tags_envelope.xml")
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
          '[[Synopsis:::STRING:::]]' : groovy.xml.XmlUtil.escapeXml(note_text)
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


        def username = springSecurityService.principal.username
        note.color = 'info'
        note.author = User.findByUsername(username)
        note.patient = Patient.get(pid)
        note.validate()

        if (note.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond note.errors, view:'index'
            return
        }
        
        note.save flush:true

        redirect action: 'index', params: [pid: pid]
    }

    def edit(Note note) {
        respond note
    }

    @Transactional
    def update(Note note) {
        if (note == null) {
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
    def delete(Note note) {

        if (note == null) {
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
