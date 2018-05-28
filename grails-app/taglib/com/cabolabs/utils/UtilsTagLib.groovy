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
}
