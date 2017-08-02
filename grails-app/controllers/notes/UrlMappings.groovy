package notes

class UrlMappings {

    static mappings = {
        "/$controller/$action?/$id?(.$format)?"{
            constraints {
                // apply constraints here
            }
        }

        //"/"(view:"/index")
        "/" {
            controller = 'dashboard'
            action = 'index'
        }

        post "/user/signup" (controller:'user', action:'dosignup')

        "500"(view:'/error')
        "404"(view:'/notFound')
    }
}
