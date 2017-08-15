package com.cabolabs.notes

import grails.transaction.Transactional

import java.text.SimpleDateFormat
import com.cabolabs.security.*

@Transactional
class EhrServerService {

   def prepareCommit(Note note, User committer)
   {
      String PS = System.getProperty("file.separator")

      // TODO: full path prefix should be ENV
      //def template_document = new File("openehr" +PS+ "Psychotherapy_Note_tags_envelope.xml")
      def template_document = new File("openehr" +PS+ "with_category" +PS+ "Psychotherapy_Note.EN.v1_tags_envelope.xml")
      def xml = template_document.text

      def datetime_format_openEHR = "yyyyMMdd'T'HHmmss,SSSZ"
      def format_oehr = new SimpleDateFormat(datetime_format_openEHR)
      def str_date_openEHR = format_oehr.format(new Date())
      println str_date_openEHR

      def note_text = note.text.replace('&', '&amp;')
      println note_text


      def data = [
        '[[CONTRIBUTION:::UUID:::ANY]]'          : java.util.UUID.randomUUID() as String,
        '[[COMMITTER_ID:::UUID:::ANY]]'          : committer.uid,
        '[[COMMITTER_NAME:::STRING:::Dr. House]]': committer.name+" "+committer.lastname,
        '[[TIME_COMMITTED:::DATETIME:::NOW]]'    : str_date_openEHR,
        '[[VERSION_ID:::VERSION_ID:::ANY]]'      : (java.util.UUID.randomUUID() as String) +'::PSY.NOTES::1',
        '[[COMPOSITION:::UUID:::ANY]]'           : java.util.UUID.randomUUID() as String,
        '[[COMPOSITION_DATE:::DATETIME:::NOW]]'  : str_date_openEHR,
        '[[Synopsis:::STRING:::]]'               : groovy.xml.XmlUtil.escapeXml(note_text),
        '[[Category.Name]]'                      : note.category.name,
        '[[Category.Code]]'                      : note.category.uid
      ]

      data.each { k, v ->
         println "$k : $v"
         xml = xml.replace(k, v) // reaplace all strings
      }
      //println xml

      // TODO: absolute path prefix should be ENV
      // generate file to commit
      def out = new File("documents" +PS+ "pending" +PS+ data['[[COMPOSITION:::UUID:::ANY]]'] +".xml")
      out << xml
   }
}