package com.cabolabs.i18n.notes

import grails.config.Config
import grails.core.support.GrailsConfigurationAware
import org.springframework.context.MessageSource
import org.springframework.web.servlet.support.RequestContextUtils

class LocaleSelectorTagLib implements GrailsConfigurationAware {

    static defaultEncodeAs = [taglib:'none']
    //static encodeAsForTags = [tagName: [taglib:'html'], otherTagName: [taglib:'none']

    MessageSource messageSource

    List<String> languages

    @Override
    void setConfiguration(Config co)
    {
        languages = co.getProperty('languages', List) 
    }

    def localeSelector = { args ->
        String uri = args.uri
        out << '<ul class="locale-selector">'
        for ( String lang : languages )
        {
            String languageCode = "language.$lang"
            def locale = RequestContextUtils.getLocale(request)
            def msg = messageSource.getMessage(languageCode, [] as Object[], null, locale)
            if (lang == locale.language)
               out << "<li><b><a href='${uri}?lang=${lang}'>${msg}</a></b></li>"
            else
               out << "<li><a href='${uri}?lang=${lang}'>${msg}</a></li>"
        }
        out << '</ul>'
    }
}
