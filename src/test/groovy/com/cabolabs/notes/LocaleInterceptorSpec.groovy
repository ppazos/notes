package com.cabolabs.notes


import grails.test.mixin.TestFor
import spock.lang.Specification

/**
 * See the API for {@link grails.test.mixin.web.ControllerUnitTestMixin} for usage instructions
 */
@TestFor(LocaleInterceptor)
class LocaleInterceptorSpec extends Specification {

    def setup() {
    }

    def cleanup() {

    }

    void "Test locale interceptor matching"() {
        when:"A request matches the interceptor"
            withRequest(controller:"locale")

        then:"The interceptor does match"
            interceptor.doesMatch()
    }
}
