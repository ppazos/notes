package com.cabolabs.security

import groovy.transform.EqualsAndHashCode
import groovy.transform.ToString
import grails.compiler.GrailsCompileStatic

@GrailsCompileStatic
@EqualsAndHashCode(includes='username')
@ToString(includes='username', includeNames=true, includePackage=false)
class User implements Serializable {

	private static final long serialVersionUID = 1

	// domain attributes
	String uid = java.util.UUID.randomUUID() as String
	String name
	String lastname

	String username // is the email
	String password
	boolean enabled = true
	boolean accountExpired
	boolean accountLocked
	boolean passwordExpired

	String resetPasswordToken

	Set<Role> getAuthorities() {
		(UserRole.findAllByUser(this) as List<UserRole>)*.role as Set<Role>
	}

	static constraints = {
		password blank: false, password: true
		username blank: false, unique: true, email: true
		resetPasswordToken nullable: true
	}

	static mapping = {
		password column: '`password`'
	}

	static transients = ['passwordToken']

	def assignPassword(String pass)
	{
		this.password = pass
		this.resetPasswordToken = null
		this.enabled = true
	}

	def setPasswordToken()
	{
		this.resetPasswordToken = java.util.UUID.randomUUID() as String
	}
}
