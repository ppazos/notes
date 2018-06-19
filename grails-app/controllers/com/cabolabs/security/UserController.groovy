package com.cabolabs.security

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.converters.JSON
import com.cabolabs.notes.Plan

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

      def ur = UserRole.create user, Role.findByAuthority('ROLE_CLIN'), true
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
   def feedback()
   {
   }

   def index(Integer max)
   {
      [plans: Plan.list()]
   }

   def users_table(Integer max)
   {
      //def loggedInUser = springSecurityService.currentUser
      params.max = Math.min(max ?: 10, 100)

      def c = User.createCriteria()
      def userList =  c.list(params) {
        //eq('owner', loggedInUser)
      }

      render(template: "users_table", model: [userList: userList])
   }

   /**
    * Admin manually registers a user.
    */
   @Transactional
   def save(User user)
   {
      if (user == null)
      {
         transactionStatus.setRollbackOnly()
         notFound()
         return
      }

      //user.username = params.email

      // temp password, user disabled until pass reset
      user.password = java.util.UUID.randomUUID() as String
      user.enabled = false
      user.setPasswordToken()

      user.validate()

      if (user.hasErrors())
      {
         transactionStatus.setRollbackOnly()
         render user.errors.fieldErrors as JSON, status: 400, contentType: "application/json"
         return
      }

      user.save flush:true

      // User role
      def ur = UserRole.create user, Role.findByAuthority('ROLE_CLIN'), true

      // User plan
      def plan = Plan.get(params.plan)
      if (!plan)
      {
         // simulates a validation error
         render ([[
                  arguments: ['plan', 'com.cabolabs.security.User'],
                  code: 'nullable',
                  codes: ['user.plan.notFound'],
                  field: 'plan'
                 ]] as JSON, status: 400, contentType: "application/json")
         return
      }

      try
      {
         plan.associateTo(user) // creates plan assoc
      }
      catch (Exception e)
      {
         render ([[
                  arguments: ['plan', 'com.cabolabs.security.User'],
                  code: 'nullable',
                  codes: ['user.plan.cantCreateAssociation'],
                  field: 'plan'
                 ]] as JSON, status: 400, contentType: "application/json")
         return
      }


      // Welcome email (TODO job)
      def g = grailsApplication.mainContext.getBean('org.grails.plugins.web.taglib.ApplicationTagLib')
      def u = g.createLink(controller:'user', action:'reset', absolute:true, params:[token:user.resetPasswordToken])
      def s = message(code:'register.subject')
      def b = message(code:'register.body', args:[u])
      Thread.start { // TODO: try/catch this and log the error to try again later.
         sendMail {
            to user.username //"pablo.swp@gmail.com"
            //subject "Welcome to notes!"
            //html '<b>Welcome!</b> <a href="'+ u +'">Set your password</a>'
            subject s
            html b
         }
      }

      session.feedback = message(code:'user.register.done', args:[user.username])

      redirect action:'users_table'
   }

   /**
    * Admin reminds inactive users to set a password to their account.
    */
   def remind(Long id)
   {
      def user = User.get(id)
      if (!user)
      {
         render ([error: true, message: message(code:'user.feedback.not_found')] as JSON, status: 404, contentType: "application/json")
         return
      }

      // Welcome email (TODO job)
      def g = grailsApplication.mainContext.getBean('org.grails.plugins.web.taglib.ApplicationTagLib')
      def u = g.createLink(controller:'user', action:'reset', absolute:true, params:[token:user.resetPasswordToken])
      def s = message(code:'register.subject')
      def b = message(code:'register.body', args:[u])

      try
      {
         sendMail {
            to user.username
            subject s
            html b
         }
      }
      catch (Exception e)
      {
         render ([error: true, message: e.message] as JSON, status: 400, contentType: "application/json")
         return
      }

      render ([error: false, message: message(code:'user.feedback.reminder_sent')] as JSON, status: 200, contentType: "application/json")
   }

   def show(Long id)
   {
      def user = User.get(id)
      if (!user)
      {
         render ([error: true, message: message(code:'user.feedback.not_found')] as JSON, status: 404, contentType: "application/json")
         return
      }

      def plan_assoc = Plan.associatedNow(user)

      // TODO: user json marshaller
      //
      render ([username: user.username, name: user.name, lastname: user.lastname, phone: user.phone, sex: user.sex, organization: user.organization,
               plan: plan_assoc.plan.id] as JSON, status: 200, contentType: "application/json")
   }

   @Transactional
   def update(Long id)
   {
      def user = User.get(id)
      if (!user)
      {
         render ([error: true, message: message(code:'user.feedback.not_found')] as JSON, status: 404, contentType: "application/json")
         return
      }

      user.properties = params

      user.validate()

      if (user.hasErrors())
      {
         transactionStatus.setRollbackOnly()
         render user.errors.fieldErrors as JSON, status: 400, contentType: "application/json"
         return
      }

      user.save flush:true

      // TODO: update plan confirm

      session.feedback = message(code:'user.modified.done', args:[user.username])

      redirect action:'users_table'
   }

    /*
    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def show(User user) {
        respond user
    }

    def create() {
        respond new User(params)
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
