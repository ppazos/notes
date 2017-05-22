package notes

import com.cabolabs.security.*
import com.cabolabs.notes.*

class BootStrap {

    def springSecurityService

    def init = { servletContext ->

        def adminRole = Role.findOrSaveByAuthority('ROLE_ADMIN')
        def admin

        if (!User.findByUsername('admin'))
        {
            admin = new User(username: 'admin', password: 'admin').save(failOnError:true)

            UserRole.create admin, adminRole

            User.withSession { it.flush() }
        }


        def patient = new Patient(name: 'Manuel',
                                  lastname: 'Perez',
                                  phone: '2523452542',
                                  sex: 'M',
                                  dob: (new Date() - (10*365))).save(failOnError: true)

        (1..20).each {
            new Note(
                color: 'success',
                text: 'dfas sdf a asfasf asdasdf asd fas fas fasdfasdf asdf as fas dfas fasd fasf as dfasd fasd fasdf asdf asdf asdf asdfas fasd fasd fas dfasd fasd fasdf asf asdfasd fasdfa',
                author: admin,
                patient: patient).save(failOnError: true)
        }



        for (String url in [
		      '/', '/error', '/index', '/index.gsp', '/**/favicon.ico', '/shutdown',
		      '/**/js/**', '/**/css/**', '/**/images/**',
		      '/login', '/login.*', '/login/*',
		      '/logout', '/logout.*', '/logout/*']) {
		   new RequestMap(url: url, configAttribute: 'permitAll').save()
		}

        new RequestMap(url: '/dbconsole/**', configAttribute: 'ROLE_ADMIN').save()
        new RequestMap(url: '/note/**', configAttribute: 'ROLE_ADMIN').save()
        new RequestMap(url: '/patient/**', configAttribute: 'ROLE_ADMIN').save()


        springSecurityService.clearCachedRequestmaps()
    }
    def destroy = {
    }
}
