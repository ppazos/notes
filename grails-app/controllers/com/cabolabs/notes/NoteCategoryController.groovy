package com.cabolabs.notes

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional

import com.cabolabs.security.*

@Transactional(readOnly = true)
class NoteCategoryController {

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def springSecurityService

    def index(Integer max) {
        def loggedInUser = springSecurityService.currentUser
        params.max = Math.min(max ?: 10, 100)
        respond NoteCategory.findAllByOwner(loggedInUser, params), model:[noteCategoryCount: NoteCategory.countByOwner(loggedInUser)]
    }

    def show(NoteCategory noteCategory) {
        respond noteCategory
    }

    def create() {
        respond new NoteCategory(params)
    }

    @Transactional
    def save(NoteCategory noteCategory)
    {
        if (noteCategory == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        def loggedInUser = springSecurityService.currentUser
        noteCategory.owner = loggedInUser
        noteCategory.validate()

        if (noteCategory.hasErrors())
        {
            transactionStatus.setRollbackOnly()
            respond noteCategory.errors, view:'create'
            return
        }

        noteCategory.save flush:true

        redirect action: 'index'
    }

    def edit(NoteCategory noteCategory) {
        respond noteCategory
    }

    @Transactional
    def update(NoteCategory noteCategory) {
        if (noteCategory == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (noteCategory.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond noteCategory.errors, view:'edit'
            return
        }

        noteCategory.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'noteCategory.label', default: 'NoteCategory'), noteCategory.id])
                redirect noteCategory
            }
            '*'{ respond noteCategory, [status: OK] }
        }
    }

    @Transactional
    def delete(NoteCategory noteCategory) {

        if (noteCategory == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        noteCategory.delete flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'noteCategory.label', default: 'NoteCategory'), noteCategory.id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'noteCategory.label', default: 'NoteCategory'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}