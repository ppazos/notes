package com.cabolabs.exceptions

import com.cabolabs.security.User

class UserDoesntHaveAPlanException extends Exception {

   User user

   public UserDoesntHaveAPlanException(User user, String message)
   {
      super(message)
   }
}
