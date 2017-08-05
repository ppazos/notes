package com.cabolabs.notes

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.converters.JSON

@Transactional(readOnly = true)
class TimeSlotController {

    def springSecurityService

    static allowedMethods = [save: "POST", update: "POST", delete: "DELETE"]

    def index(Integer max) {
        
    }

    def timeslot_list(Integer max)
    {
        def loggedInUser = springSecurityService.currentUser
        params.max = Math.min(max ?: 10, 100)
        render TimeSlot.findAllByOwner(loggedInUser, params) as JSON //, model:[timeSlotCount: TimeSlot.count()]
    }

    def show(TimeSlot timeSlot) {
        respond timeSlot
    }

    def create() {
        respond new TimeSlot(params)
    }

    @Transactional
    def save(TimeSlot timeSlot)
    {
        println "save"
        println params

        if (timeSlot == null)
        {
            transactionStatus.setRollbackOnly()
            render text: [result: 'NO_CONTENT'] as JSON, status: 400, contentType: "application/json"
            return
        }

        def loggedInUser = springSecurityService.currentUser
        timeSlot.uid = java.util.UUID.randomUUID() as String

println timeSlot.uid

        timeSlot.owner = loggedInUser
        timeSlot.validate()

        if (timeSlot.hasErrors())
        {
            transactionStatus.setRollbackOnly()
            //respond timeSlot.errors, view:'create'

/*

[{"arguments":["status","com.cabolabs.notes.TimeSlot"],"bindingFailure":false,"code":"nullable","codes":["com.cabolabs.notes.TimeSlot.status.nullable.error.com.cabolabs.notes.TimeSlot.status","com.cabolabs.notes.TimeSlot.status.nullable.error.status","com.cabolabs.notes.TimeSlot.status.nullable.error.java.lang.String","com.cabolabs.notes.TimeSlot.status.nullable.error","timeSlot.status.nullable.error.com.cabolabs.notes.TimeSlot.status","timeSlot.status.nullable.error.status","timeSlot.status.nullable.error.java.lang.String","timeSlot.status.nullable.error","com.cabolabs.notes.TimeSlot.status.nullable.com.cabolabs.notes.TimeSlot.status","com.cabolabs.notes.TimeSlot.status.nullable.status","com.cabolabs.notes.TimeSlot.status.nullable.java.lang.String","com.cabolabs.notes.TimeSlot.status.nullable","timeSlot.status.nullable.com.cabolabs.notes.TimeSlot.status","timeSlot.status.nullable.status","timeSlot.status.nullable.java.lang.String","timeSlot.status.nullable","nullable.com.cabolabs.notes.TimeSlot.status","nullable.status","nullable.java.lang.String","nullable"],"defaultMessage":"La propiedad [{0}] de la clase [{1}] no puede ser nulo","field":"status","objectName":"com.cabolabs.notes.TimeSlot","rejectedValue":null},{"arguments":["scheduledOn","com.cabolabs.notes.TimeSlot"],"bindingFailure":false,"code":"nullable","codes":["com.cabolabs.notes.TimeSlot.scheduledOn.nullable.error.com.cabolabs.notes.TimeSlot.scheduledOn","com.cabolabs.notes.TimeSlot.scheduledOn.nullable.error.scheduledOn","com.cabolabs.notes.TimeSlot.scheduledOn.nullable.error.java.util.Date","com.cabolabs.notes.TimeSlot.scheduledOn.nullable.error","timeSlot.scheduledOn.nullable.error.com.cabolabs.notes.TimeSlot.scheduledOn","timeSlot.scheduledOn.nullable.error.scheduledOn","timeSlot.scheduledOn.nullable.error.java.util.Date","timeSlot.scheduledOn.nullable.error","com.cabolabs.notes.TimeSlot.scheduledOn.nullable.com.cabolabs.notes.TimeSlot.scheduledOn","com.cabolabs.notes.TimeSlot.scheduledOn.nullable.scheduledOn","com.cabolabs.notes.TimeSlot.scheduledOn.nullable.java.util.Date","com.cabolabs.notes.TimeSlot.scheduledOn.nullable","timeSlot.scheduledOn.nullable.com.cabolabs.notes.TimeSlot.scheduledOn","timeSlot.scheduledOn.nullable.scheduledOn","timeSlot.scheduledOn.nullable.java.util.Date","timeSlot.scheduledOn.nullable","nullable.com.cabolabs.notes.TimeSlot.scheduledOn","nullable.scheduledOn","nullable.java.util.Date","nullable"],"defaultMessage":"La propiedad [{0}] de la clase [{1}] no puede ser nulo","field":"scheduledOn","objectName":"com.cabolabs.notes.TimeSlot","rejectedValue":null}]
*/

            render text: timeSlot.errors.fieldErrors as JSON, status: 400, contentType: "application/json"
            return
        }

        timeSlot.save flush:true

/*
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'timeSlot.label', default: 'TimeSlot'), timeSlot.id])
                redirect timeSlot
            }
            '*' { respond timeSlot, [status: CREATED] }
        }
*/
        render text: [result: 'OK'] as JSON, status: 201, contentType: "application/json"
        return
    }

    def edit(TimeSlot timeSlot) {
        respond timeSlot
    }

    @Transactional
    def update()
    {
        println "timeslot update"
        println params

        def timeSlot = TimeSlot.findByUid(params.uid)
        
        if (timeSlot == null)
        {
            transactionStatus.setRollbackOnly()
            render text: [result: 'NO_CONTENT'] as JSON, status: 400, contentType: "application/json"
            return
        }

        def wasScheduled = (timeSlot.status == 'scheduled')

        timeSlot.properties = params
        
        if (timeSlot.status == 'scheduled')
        {
            if (!params.scheduledForUid)
            {
                render text: [result: 'NO_CONTENT'] as JSON, status: 400, contentType: "application/json"
                return
            }

            def patient = Patient.findByUid(params.scheduledForUid)

            if (!patient)
            {
                render text: [result: 'UNKOWN_PATIENT'] as JSON, status: 404, contentType: "application/json"
                return
            }

            // check that is my patient, throw unknown to avoid showing that the patient exists
            def loggedInUser = springSecurityService.currentUser
            if (patient.owner.id != loggedInUser.id)
            {
                render text: [result: 'UNKOWN_PATIENT'] as JSON, status: 404, contentType: "application/json"
                return
            }

            timeSlot.scheduledFor = patient
            timeSlot.scheduledOn = new Date()
        }
        else // currently open
        {
            if (wasScheduled)
            {
                println "cancel scheduled"
                timeSlot.scheduledOn = null
                timeSlot.scheduledFor = null

                // TODO: create log of cancel
                // TODO: notify patient
            }
        }

        timeSlot.validate()

        if (timeSlot.hasErrors())
        {
            transactionStatus.setRollbackOnly()
            //respond timeSlot.errors, view:'edit'
            render text: timeSlot.errors.fieldErrors as JSON, status: 400, contentType: "application/json"
            return
        }

        timeSlot.save flush:true

        render text: [result: 'OK'] as JSON, status: 201, contentType: "application/json"
        return
    }

    @Transactional
    def delete(TimeSlot timeSlot) {

        if (timeSlot == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        timeSlot.delete flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'timeSlot.label', default: 'TimeSlot'), timeSlot.id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'timeSlot.label', default: 'TimeSlot'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
