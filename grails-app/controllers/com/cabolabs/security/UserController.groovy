package com.cabolabs.security

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional

@Transactional(readOnly = true)
class UserController {

    static allowedMethods = [dosignup: "POST"]

    def signup()
    {
        /*
        if (!params.submit)
        {
            return params
        }
        */
    }

    def dosignup(String name, String lastname, String username)
    {
       println params

       def user = new User(
        name:     name,
        lastname: lastname,
        username: username)

       // temp password, user disabled until pass reset
       user.password = java.util.UUID.randomUUID() as String
       user.enabled = false
       user.setPasswordToken()

       //user.save(failOnError: true)
       if (!user.save(flush:true))
       {
           println user.errors.allErrors
           println fieldErrors(user.errors.allErrors)
           flash.message = message(code:'user.signup.error')
           //redirect action:'signup'
           render view:'signup', model: [errors: fieldErrors(user.errors.allErrors)]
           return
       }

       // TODO: role user
       def ur = UserRole.create user, Role.findByAuthority('ROLE_ADMIN'), true
       println ur.errors


       // email
       def g = grailsApplication.mainContext.getBean('org.grails.plugins.web.taglib.ApplicationTagLib')
       def u = g.createLink(controller:'user', action:'reset', absolute:true, params:[token:user.resetPasswordToken])
       def s = message(code:'signup.subject')
       def b = message(code:'signup.body', args:[u])
       Thread.start { // TODO: try/catch this and log the error to try again later.
           sendMail {
              to user.username //"pablo.swp@gmail.com"
              //subject "Welcome to notes!"
              //html '<b>Welcome!</b> <a href="'+ u +'">Set your password</a>'
              subject s
              html b
           }
       }

       session.feedback = message(code:'user.signup.done', args:[user.username])
       redirect action:'feedback'
    }

    /*
    Error structure for showing field errors on the view.
    */
    private Map fieldErrors(allErrors)
    {
        def res = [:]
        allErrors.each {
            res[it.field] = [
                field: it.field,
                code:  it.code,
                rejectedValue: it.rejectedValue
            ]
        }
        return res
    }

    /*
    Reset password.
    */
    def reset(String token, String password, String confirm)
    {
        def user = User.findByResetPasswordToken(token)
        if (!user)
        {
            session.feedback = message(code:'user.reset.not_found')
            redirect action:'feedback'
            return
        }

        if (!params.submit)
        {
            return params // GUI
        }
        
        if (!password || !confirm)
        {
          println "missing data"
            return [
              errors: [
                password: [
                  field: 'password',
                  code:  'empty',
                  rejectedValue: password
                ],
                confirm: [
                  field: 'confirm',
                  code:  'empty',
                  rejectedValue: confirm
                ]
              ]
            ]
        }

        if (password != confirm)
        {
            return [
              errors: [
                confirm: [
                  field: 'confirm',
                  code:  'invalid',
                  rejectedValue: confirm
                ]
              ]
            ]
        }

        user.assignPassword(password)
        if (!user.save(flush:true))
        {
            println user.errors
            return params
        }

        //flash.message = message(code:'user.reset.done')
        //redirect controller:'login'

        session.feedback = message(code:'user.reset.done')
        redirect action:'feedback'
    }


    /*
    Password reset request.
    */
    def forgot(String email)
    {
        println "'"+ email +"'"
        if (!params.submit)
        {
            return params
        }

        if (!email)
        {
            return [
              errors: [
                email: [
                  field: 'email',
                  code:  'empty',
                  rejectedValue: email
                ]
              ]
            ]
        }

        def user = User.findByUsername(email)

        if (!user)
        {
            return [
              errors: [
                email: [
                  field: 'email',
                  code:  'invalid',
                  rejectedValue: email
                ]
              ]
            ]
        }

        user.setPasswordToken()
        user.save(flush:true)

        // email
        def g = grailsApplication.mainContext.getBean('org.grails.plugins.web.taglib.ApplicationTagLib')
        def u = g.createLink(controller:'user', action:'reset', absolute:true, params:[token:user.resetPasswordToken])
        def s = message(code:'forgot.subject')
        def b = message(code:'forgot.body', args:[u])

        Thread.start { // TODO: try/catch this and log the error to try again later.
            sendMail {
               to user.username //"pablo.swp@gmail.com"
               subject s
               html b
            }
        }

        session.feedback = message(code:'user.forgot.done', args:[user.username])
        redirect action:'feedback'
    }

    // generic action to show generic UI with feedback from user management
    // actions like success signup, pw reset request, etc.
    def feedback() {}


    /*
    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond User.list(params), model:[userCount: User.count()]
    }

    def show(User user) {
        respond user
    }

    def create() {
        respond new User(params)
    }

    @Transactional
    def save(User user) {
        if (user == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (user.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond user.errors, view:'create'
            return
        }

        user.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'user.label', default: 'User'), user.id])
                redirect user
            }
            '*' { respond user, [status: CREATED] }
        }
    }

    def edit(User user) {
        respond user
    }

    @Transactional
    def update(User user) {
        if (user == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (user.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond user.errors, view:'edit'
            return
        }

        user.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'user.label', default: 'User'), user.id])
                redirect user
            }
            '*'{ respond user, [status: OK] }
        }
    }

    @Transactional
    def delete(User user) {

        if (user == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        user.delete flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'user.label', default: 'User'), user.id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'user.label', default: 'User'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
    */
}
