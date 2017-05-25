package com.cabolabs.notes

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional

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

        /*
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'note.label', default: 'Note'), note.id])
                redirect note
            }
            '*' { respond note, [status: CREATED] }
        }
        */
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
