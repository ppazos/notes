package notes

import com.cabolabs.security.*
import com.cabolabs.notes.*
import com.cabolabs.ehrserver.* // groovy client
import grails.converters.JSON

class BootStrap {

    def springSecurityService
    def mailService

    def init = { servletContext ->

        // Define server timezone
        TimeZone.setDefault(TimeZone.getTimeZone("UTC"))

/*
        mailService.sendMail {
            to "pablo.swp@gmail.com"
            subject "Hello John"
            html "<b>Hello</b> World"
        }
*/

        // JSON Marshallers
        registerJSONMarshallers()

/*
println ">>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        // test
        // ehrserver-cabolabs2.rhcloud.com
        //def ehrserver = new EhrServerClient('https://', 'cabolabs-ehrserver.rhcloud.com', 443, '/')
        //def token = ehrserver.login('userx', 'user', '123456')
        def ehrserver = new EhrServerClient('http://', '192.168.1.108', 8090, '/ehr/')
        def token = ehrserver.login('user', 'user', '123456')
        //println token
        def result = ehrserver.getEhrs()
        result.ehrs.each {
          println it
        }
println "<<<<<<<<<<<<<<<<<<<<<<<<<<<"
*/

        // Roles
        def adminRole = Role.findOrSaveByAuthority('ROLE_ADMIN')
        def clinicianRole = Role.findOrSaveByAuthority('ROLE_CLIN')
        def patientRole = Role.findOrSaveByAuthority('ROLE_PAT')

        def admin = User.findByUsername('admin@admin.com')

        if (!admin)
        {
            admin = new User(username: 'admin@admin.com', password: 'admin',
                             name: 'Pablo', lastname: 'Pazos').save(failOnError:true)

            UserRole.create admin, adminRole

            User.withSession { it.flush() }
        }

        def user = User.findByUsername('user@user.com')
        // other user
        if (!user)
        {
            user = new User(username: 'user@user.com', password: 'user',
                            name: 'User', lastname: 'Resu').save(failOnError:true)

            UserRole.create user, adminRole

            User.withSession { it.flush() }
        }

        if (Patient.count() == 0)
        {
            def patient = new Patient(name: 'Manuel',
                                      lastname: 'Perez',
                                      phone: '2523452542',
                                      sex: 'M',
                                      email: 'man@uel.com',
                                      dob: (new Date() - (10*365)),
                                      owner: admin).save(failOnError: true)
            def patient2 = new Patient(name: 'Carol',
                                      lastname: 'Suarez',
                                      phone: '5555224234',
                                      sex: 'F',
                                      email: 'car@ol.com',
                                      dob: (new Date() - (25*365)),
                                      owner: admin).save(failOnError: true)
            def patient3 = new Patient(name: 'Carlos',
                                      lastname: 'Perez',
                                      phone: '54745477547',
                                      sex: 'M',
                                      email: 'car@los.com',
                                      dob: (new Date() - (29*365)),
                                      owner: admin).save(failOnError: true)
            def patient4 = new Patient(name: 'Miguel',
                                      lastname: 'Rodriguez',
                                      phone: '36346363643',
                                      sex: 'M',
                                      email: 'mi@guel.com',
                                      dob: (new Date() - (63*365)),
                                      owner: admin).save(failOnError: true)

            def cat1 = new NoteCategory(name: 'Patient', owner: admin).save(failOnError: true)
            def cat2 = new NoteCategory(name: 'Family', owner: admin).save(failOnError: true)
            def cat3 = new NoteCategory(name: 'Work', owner: admin).save(failOnError: true)

            (1..5).each {
                new Note(
                    color: 'success',
                    text: 'dfas sdf a asfasf asdasdf asd fas fas fasdfasdf asdf as fas dfas fasd fasf as dfasd fasd fasdf asdf asdf asdf asdfas fasd fasd fas dfasd fasd fasdf asf asdfasd fasdfa',
                    author: admin,
                    patient: patient,
                    category: cat1).save(failOnError: true)
            }
        }

        for (String url in [
          '/error', '/index', '/index.gsp', '/**/favicon.ico', '/shutdown',
          '/**/js/**', '/**/css/**', '/**/images/**', '/**/fonts/**',
          '/login', '/login.*', '/login/*',
          '/logout', '/logout.*', '/logout/*',
          '/user/signup',
          '/user/reset',
          '/user/forgot',
          '/user/feedback']) {
       new RequestMap(url: url, configAttribute: 'permitAll').save()
    }

        new RequestMap(url: '/', configAttribute: 'ROLE_ADMIN').save()
        new RequestMap(url: '/dbconsole/**', configAttribute: 'ROLE_ADMIN').save()
        new RequestMap(url: '/note/**', configAttribute: 'ROLE_ADMIN').save()
        new RequestMap(url: '/patient/**', configAttribute: 'ROLE_ADMIN').save()
        new RequestMap(url: '/timeSlot/**', configAttribute: 'ROLE_ADMIN').save()
        new RequestMap(url: '/noteCategory/**', configAttribute: 'ROLE_ADMIN').save()
        new RequestMap(url: '/dashboard/**', configAttribute: 'ROLE_ADMIN').save()

        springSecurityService.clearCachedRequestmaps()
    }
    def destroy = {
    }

   def registerJSONMarshallers()
   {
      JSON.registerObjectMarshaller(TimeSlot) { ts ->
        return [id:     ts.uid,
                start:  ts.start,
                end:    ts.end,
                duration: ts.durationInMinutes,
                title:  ts.name,
                color:  ts.color,
                status: ts.status,
                scheduledOn: ts.scheduledOn,
                scheduledFor: ts.scheduledFor
               ]
      }
   }
}
