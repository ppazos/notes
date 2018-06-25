package com.cabolabs.notes

import java.util.TimeZone
import org.springframework.beans.propertyeditors.LocaleEditor
import org.springframework.web.servlet.support.RequestContextUtils

class LocaleInterceptor {

    LocaleInterceptor()
    {
        matchAll() // .excludes(controller:"xxx")
    }
    boolean before() {

       println "LocaleInterceptor params "+ params

       // Set timezone of client to show formatted dates stored in UTC,
       // in the timezone of the client.
       if (params.tz) session.tz = TimeZone.getTimeZone('GMT'+params.tz)

       if (params.lang)
       {
         //println request.getClass()
         println request.locales.collect()
         println 'request locale '+ request.locale
         println 'session locale '+ session.'org.springframework.web.servlet.i18n.SessionLocaleResolver.LOCALE'

/* grails does this internally when receiving the lang param.
         def localeResolver = RequestContextUtils.getLocaleResolver(request)
         def localeEditor = new LocaleEditor()
         localeEditor.setAsText params.lang
         localeResolver?.setLocale request, response, (Locale)localeEditor.value
*/
         //request.addPreferredLocale (Locale)localeEditor.value
//println request.locales.collect()
println 'request locale 2 '+ request.locale // stays on the same locale
println 'session locale 2 '+ session.'org.springframework.web.servlet.i18n.SessionLocaleResolver.LOCALE' // changes!

//println request.request.getClass() // request is a wrapper of the real request


         //java.util.Locale.setDefault((Locale)localeEditor.value)
       }
       true
    }

    boolean after() { true }

    void afterView() {
        // no-op
    }
}
