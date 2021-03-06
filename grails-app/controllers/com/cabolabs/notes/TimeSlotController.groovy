package com.cabolabs.notes

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.converters.JSON
import groovy.time.*

@Transactional(readOnly = true)
class TimeSlotController {

   def springSecurityService

   static allowedMethods = [save: "POST", update: "POST", delete: "DELETE"]

   def index(Integer max) {

   }

   def timeslot_list(Integer max, String start, String end)
   {
      def dstart, dend
      if (start) dstart = Date.parse("yyyy-MM-dd", start)
      if (end) dend = Date.parse("yyyy-MM-dd", end)

      def loggedInUser = springSecurityService.currentUser
      params.max = Math.min(max ?: 10, 100)
      def list = TimeSlot.withCriteria {
         eq('owner', loggedInUser)
         ge('start', dstart)
         le('start', dend)
      }
      //render TimeSlot.findAllByOwner(loggedInUser, params) as JSON //, model:[timeSlotCount: TimeSlot.count()]
      render list as JSON
   }

   def show(TimeSlot timeSlot) {
      respond timeSlot
   }

   def create() {
      respond new TimeSlot(params)
   }

    @Transactional
    def save(TimeSlot timeSlot, String repeat, int times, String pid)
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
        //timeSlot.uid = java.util.UUID.randomUUID() as String // there is an uid field on the ui that comes empty on creation and is binded as null

        // schedule on creation?
        if (timeSlot.status == 'scheduled')
        {
            if (!pid)
            {
                render text: [result: 'NO_CONTENT'] as JSON, status: 400, contentType: "application/json"
                return
            }

            def patient = Patient.get(pid)
            if (!patient)
            {
                render text: [result: 'UNKOWN_PATIENT'] as JSON, status: 404, contentType: "application/json"
                return
            }

            // check that is my patient, throw unknown to avoid showing that the patient exists
            if (patient.owner.id != loggedInUser.id)
            {
                render text: [result: 'UNKOWN_PATIENT'] as JSON, status: 404, contentType: "application/json"
                return
            }

            timeSlot.scheduledFor = patient
            timeSlot.scheduledOn = new Date()
        }

        // periodic events?
        def repeatTimeSlots = [] // user to create other TS in the series
        if (repeat != 'once')
        {
           def start = timeSlot.start
           def end   = timeSlot.end
           def period
           if (repeat == 'weekly')
           {
              //period = 7
              period = 'week'
           }
           if (repeat == 'monthly')
           {
              //period = 30 // TODO: same day next month is not exactly now + 30
              period = 'month'
           }

           // -1 because the initial ts counts in the total
           (times-1).times { i ->

              use (TimeCategory) {
                 start += 1."$period"
                 end += 1."$period"
              }

              println start

              repeatTimeSlots << new TimeSlot(
                 start: start, end: end,
                 name: timeSlot.name, owner: loggedInUser,
                 color: timeSlot.color, status: timeSlot.status,
                 scheduledFor: timeSlot.scheduledFor,
                 scheduledOn: timeSlot.scheduledOn)
           }
        }

        timeSlot.owner = loggedInUser
        timeSlot.validate()

        if (timeSlot.hasErrors())
        {
           transactionStatus.setRollbackOnly()
           //respond timeSlot.errors, view:'create'

           println timeSlot.errors

/*

[{"arguments":["status","com.cabolabs.notes.TimeSlot"],"bindingFailure":false,"code":"nullable","codes":["com.cabolabs.notes.TimeSlot.status.nullable.error.com.cabolabs.notes.TimeSlot.status","com.cabolabs.notes.TimeSlot.status.nullable.error.status","com.cabolabs.notes.TimeSlot.status.nullable.error.java.lang.String","com.cabolabs.notes.TimeSlot.status.nullable.error","timeSlot.status.nullable.error.com.cabolabs.notes.TimeSlot.status","timeSlot.status.nullable.error.status","timeSlot.status.nullable.error.java.lang.String","timeSlot.status.nullable.error","com.cabolabs.notes.TimeSlot.status.nullable.com.cabolabs.notes.TimeSlot.status","com.cabolabs.notes.TimeSlot.status.nullable.status","com.cabolabs.notes.TimeSlot.status.nullable.java.lang.String","com.cabolabs.notes.TimeSlot.status.nullable","timeSlot.status.nullable.com.cabolabs.notes.TimeSlot.status","timeSlot.status.nullable.status","timeSlot.status.nullable.java.lang.String","timeSlot.status.nullable","nullable.com.cabolabs.notes.TimeSlot.status","nullable.status","nullable.java.lang.String","nullable"],"defaultMessage":"La propiedad [{0}] de la clase [{1}] no puede ser nulo","field":"status","objectName":"com.cabolabs.notes.TimeSlot","rejectedValue":null},{"arguments":["scheduledOn","com.cabolabs.notes.TimeSlot"],"bindingFailure":false,"code":"nullable","codes":["com.cabolabs.notes.TimeSlot.scheduledOn.nullable.error.com.cabolabs.notes.TimeSlot.scheduledOn","com.cabolabs.notes.TimeSlot.scheduledOn.nullable.error.scheduledOn","com.cabolabs.notes.TimeSlot.scheduledOn.nullable.error.java.util.Date","com.cabolabs.notes.TimeSlot.scheduledOn.nullable.error","timeSlot.scheduledOn.nullable.error.com.cabolabs.notes.TimeSlot.scheduledOn","timeSlot.scheduledOn.nullable.error.scheduledOn","timeSlot.scheduledOn.nullable.error.java.util.Date","timeSlot.scheduledOn.nullable.error","com.cabolabs.notes.TimeSlot.scheduledOn.nullable.com.cabolabs.notes.TimeSlot.scheduledOn","com.cabolabs.notes.TimeSlot.scheduledOn.nullable.scheduledOn","com.cabolabs.notes.TimeSlot.scheduledOn.nullable.java.util.Date","com.cabolabs.notes.TimeSlot.scheduledOn.nullable","timeSlot.scheduledOn.nullable.com.cabolabs.notes.TimeSlot.scheduledOn","timeSlot.scheduledOn.nullable.scheduledOn","timeSlot.scheduledOn.nullable.java.util.Date","timeSlot.scheduledOn.nullable","nullable.com.cabolabs.notes.TimeSlot.scheduledOn","nullable.scheduledOn","nullable.java.util.Date","nullable"],"defaultMessage":"La propiedad [{0}] de la clase [{1}] no puede ser nulo","field":"scheduledOn","objectName":"com.cabolabs.notes.TimeSlot","rejectedValue":null}]
*/

            render text: timeSlot.errors.fieldErrors as JSON, status: 400, contentType: "application/json"
            return
        }

        timeSlot.save flush:true

        repeatTimeSlots.each {
           it.save flush:true

           println it.errors
        }

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
    def update(String id, String pid)
    {
        println "timeslot update"
        println params

        def timeSlot = TimeSlot.get(params.id)
        if (timeSlot == null)
        {
            transactionStatus.setRollbackOnly()
            render text: [result: 'NO_CONTENT'] as JSON, status: 400, contentType: "application/json"
            return
        }

        // timeslot loaded form the DB can be scheduled and current params.status be open, so the change is from scheduled to open
        def wasScheduled = (timeSlot.status == 'scheduled')

        timeSlot.properties = params // binds status if that comes

        if (params.status == 'scheduled')
        {
            // only updates the scheduledFor if a pid comes
            // the case that the slot is scheduled, and then moved, doesnt send a pid, so scheduledFor should not be updated
            if (pid)
            {
               def patient = Patient.get(pid)
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
        }
        else if (params.status == 'open')
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

        // if status is not coming, e.g. event was just moved, it doesnt change the status or the scheduledFor

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
