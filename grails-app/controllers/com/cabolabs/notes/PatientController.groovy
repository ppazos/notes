package com.cabolabs.notes

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.converters.JSON

@Transactional(readOnly = true)
class PatientController {

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond Patient.list(params), model:[patientCount: Patient.count()]
    }

    def show(Patient patient) {
        respond patient
    }

    def create() {
        respond new Patient(params)
    }

    @Transactional
    def save(Patient patient) {
        if (patient == null) {
            println "A"
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (patient.hasErrors()) {
            println "B"
            transactionStatus.setRollbackOnly()

            /*

[{
    "arguments": ["phone", "com.cabolabs.notes.Patient"],
    "bindingFailure": false,
    "code": "nullable",
    "codes": ["com.cabolabs.notes.Patient.phone.nullable.error.com.cabolabs.notes.Patient.phone", "com.cabolabs.notes.Patient.phone.nullable.error.phone", "com.cabolabs.notes.Patient.phone.nullable.error.java.lang.String", "com.cabolabs.notes.Patient.phone.nullable.error", "patient.phone.nullable.error.com.cabolabs.notes.Patient.phone", "patient.phone.nullable.error.phone", "patient.phone.nullable.error.java.lang.String", "patient.phone.nullable.error", "com.cabolabs.notes.Patient.phone.nullable.com.cabolabs.notes.Patient.phone", "com.cabolabs.notes.Patient.phone.nullable.phone", "com.cabolabs.notes.Patient.phone.nullable.java.lang.String", "com.cabolabs.notes.Patient.phone.nullable", "patient.phone.nullable.com.cabolabs.notes.Patient.phone", "patient.phone.nullable.phone", "patient.phone.nullable.java.lang.String", "patient.phone.nullable", "nullable.com.cabolabs.notes.Patient.phone", "nullable.phone", "nullable.java.lang.String", "nullable"],
    "defaultMessage": "La propiedad [{0}] de la clase [{1}] no puede ser nulo",
    "field": "phone",
    "objectName": "com.cabolabs.notes.Patient",
    "rejectedValue": null
}, {
    "arguments": ["dob", "com.cabolabs.notes.Patient"],
    "bindingFailure": false,
    "code": "nullable",
    "codes": ["com.cabolabs.notes.Patient.dob.nullable.error.com.cabolabs.notes.Patient.dob", "com.cabolabs.notes.Patient.dob.nullable.error.dob", "com.cabolabs.notes.Patient.dob.nullable.error.java.util.Date", "com.cabolabs.notes.Patient.dob.nullable.error", "patient.dob.nullable.error.com.cabolabs.notes.Patient.dob", "patient.dob.nullable.error.dob", "patient.dob.nullable.error.java.util.Date", "patient.dob.nullable.error", "com.cabolabs.notes.Patient.dob.nullable.com.cabolabs.notes.Patient.dob", "com.cabolabs.notes.Patient.dob.nullable.dob", "com.cabolabs.notes.Patient.dob.nullable.java.util.Date", "com.cabolabs.notes.Patient.dob.nullable", "patient.dob.nullable.com.cabolabs.notes.Patient.dob", "patient.dob.nullable.dob", "patient.dob.nullable.java.util.Date", "patient.dob.nullable", "nullable.com.cabolabs.notes.Patient.dob", "nullable.dob", "nullable.java.util.Date", "nullable"],
    "defaultMessage": "La propiedad [{0}] de la clase [{1}] no puede ser nulo",
    "field": "dob",
    "objectName": "com.cabolabs.notes.Patient",
    "rejectedValue": null
}, {
    "arguments": ["name", "com.cabolabs.notes.Patient"],
    "bindingFailure": false,
    "code": "nullable",
    "codes": ["com.cabolabs.notes.Patient.name.nullable.error.com.cabolabs.notes.Patient.name", "com.cabolabs.notes.Patient.name.nullable.error.name", "com.cabolabs.notes.Patient.name.nullable.error.java.lang.String", "com.cabolabs.notes.Patient.name.nullable.error", "patient.name.nullable.error.com.cabolabs.notes.Patient.name", "patient.name.nullable.error.name", "patient.name.nullable.error.java.lang.String", "patient.name.nullable.error", "com.cabolabs.notes.Patient.name.nullable.com.cabolabs.notes.Patient.name", "com.cabolabs.notes.Patient.name.nullable.name", "com.cabolabs.notes.Patient.name.nullable.java.lang.String", "com.cabolabs.notes.Patient.name.nullable", "patient.name.nullable.com.cabolabs.notes.Patient.name", "patient.name.nullable.name", "patient.name.nullable.java.lang.String", "patient.name.nullable", "nullable.com.cabolabs.notes.Patient.name", "nullable.name", "nullable.java.lang.String", "nullable"],
    "defaultMessage": "La propiedad [{0}] de la clase [{1}] no puede ser nulo",
    "field": "name",
    "objectName": "com.cabolabs.notes.Patient",
    "rejectedValue": null
}, {
    "arguments": ["email", "com.cabolabs.notes.Patient"],
    "bindingFailure": false,
    "code": "nullable",
    "codes": ["com.cabolabs.notes.Patient.email.nullable.error.com.cabolabs.notes.Patient.email", "com.cabolabs.notes.Patient.email.nullable.error.email", "com.cabolabs.notes.Patient.email.nullable.error.java.lang.String", "com.cabolabs.notes.Patient.email.nullable.error", "patient.email.nullable.error.com.cabolabs.notes.Patient.email", "patient.email.nullable.error.email", "patient.email.nullable.error.java.lang.String", "patient.email.nullable.error", "com.cabolabs.notes.Patient.email.nullable.com.cabolabs.notes.Patient.email", "com.cabolabs.notes.Patient.email.nullable.email", "com.cabolabs.notes.Patient.email.nullable.java.lang.String", "com.cabolabs.notes.Patient.email.nullable", "patient.email.nullable.com.cabolabs.notes.Patient.email", "patient.email.nullable.email", "patient.email.nullable.java.lang.String", "patient.email.nullable", "nullable.com.cabolabs.notes.Patient.email", "nullable.email", "nullable.java.lang.String", "nullable"],
    "defaultMessage": "La propiedad [{0}] de la clase [{1}] no puede ser nulo",
    "field": "email",
    "objectName": "com.cabolabs.notes.Patient",
    "rejectedValue": null
}, {
    "arguments": ["lastname", "com.cabolabs.notes.Patient"],
    "bindingFailure": false,
    "code": "nullable",
    "codes": ["com.cabolabs.notes.Patient.lastname.nullable.error.com.cabolabs.notes.Patient.lastname", "com.cabolabs.notes.Patient.lastname.nullable.error.lastname", "com.cabolabs.notes.Patient.lastname.nullable.error.java.lang.String", "com.cabolabs.notes.Patient.lastname.nullable.error", "patient.lastname.nullable.error.com.cabolabs.notes.Patient.lastname", "patient.lastname.nullable.error.lastname", "patient.lastname.nullable.error.java.lang.String", "patient.lastname.nullable.error", "com.cabolabs.notes.Patient.lastname.nullable.com.cabolabs.notes.Patient.lastname", "com.cabolabs.notes.Patient.lastname.nullable.lastname", "com.cabolabs.notes.Patient.lastname.nullable.java.lang.String", "com.cabolabs.notes.Patient.lastname.nullable", "patient.lastname.nullable.com.cabolabs.notes.Patient.lastname", "patient.lastname.nullable.lastname", "patient.lastname.nullable.java.lang.String", "patient.lastname.nullable", "nullable.com.cabolabs.notes.Patient.lastname", "nullable.lastname", "nullable.java.lang.String", "nullable"],
    "defaultMessage": "La propiedad [{0}] de la clase [{1}] no puede ser nulo",
    "field": "lastname",
    "objectName": "com.cabolabs.notes.Patient",
    "rejectedValue": null
}]

            */
            render patient.errors.fieldErrors as JSON
            //respond patient.errors, view:'create'
            return
        }

        patient.save flush:true

        // TODO: return the html update to the list to update the partial
        render patient as JSON

    
        /* redirects to show
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'patient.label', default: 'Patient'), patient.id])
                redirect patient
            }
            '*' { respond patient, [status: CREATED] }
        }
        */
    }

    def edit(Patient patient) {
        respond patient
    }

    @Transactional
    def update(Patient patient) {
        if (patient == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (patient.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond patient.errors, view:'edit'
            return
        }

        patient.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'patient.label', default: 'Patient'), patient.id])
                redirect patient
            }
            '*'{ respond patient, [status: OK] }
        }
    }

    @Transactional
    def delete(Patient patient) {

        if (patient == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        patient.delete flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'patient.label', default: 'Patient'), patient.id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'patient.label', default: 'Patient'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
