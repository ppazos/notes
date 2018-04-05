import com.cabolabs.security.UserPasswordEncoderListener

import org.springframework.web.servlet.i18n.SessionLocaleResolver

// Place your Spring DSL code here
beans = {
    
    localeResolver(SessionLocaleResolver) {
        defaultLocale = new java.util.Locale('en') // Default locale
    }

    userPasswordEncoderListener(UserPasswordEncoderListener, ref('hibernateDatastore'))
}
