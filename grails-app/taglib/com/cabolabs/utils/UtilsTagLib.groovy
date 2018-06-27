package com.cabolabs.utils

class UtilsTagLib {

   static defaultEncodeAs = [taglib:'raw']
   //static encodeAsForTags = [tagName: [taglib:'html'], otherTagName: [taglib:'none']]

   //def grailsApplication

   def ifConfig = { attrs, body ->

      def configKey = attrs.configKey
      if (!configKey) throw new Exception('Attribute configKey is mandatory')

      def value = grailsApplication.config.getProperty(configKey, Boolean)

      if (value == null) throw new Exception('Config '+ configKey +' not found')

      if (value)
      {
         out << body()
      }
   }

   // https://github.com/ppazos/notes/issues/95
   // shows session.feedback and removes it after showing, to avoid displaying twice
   // is used to display feedback after redirect without the need of passing a param
   def feedbackAlert = { attrs, body ->

      if (session.feedback)
      {
         out << '<div class="alert alert-custom fade in alert-dismissable show">'
         out << '  <button type="button" class="close" data-dismiss="alert" aria-label="Close">'
         out << '    <span aria-hidden="true" style="font-size:20px">&times;</span>'
         out << '  </button>'+ session.feedback +'</div>'

         if (attrs.clean)
            session.feedback = null
      }
   }

   def feedbackPlain = { attrs, body ->

      if (session.feedback)
      {
         out << '<div class="feedback">'+ session.feedback +'</div>'

         if (attrs.clean)
            session.feedback = null
      }
   }
}
