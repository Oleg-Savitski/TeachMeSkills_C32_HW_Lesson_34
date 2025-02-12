package com.teachmeskills.lesson_34.e_library_app.exception;

public class UserDAOException extends Exception {
    public UserDAOException(String message) {
        super(message);
    }

    public UserDAOException(String message, Throwable cause) {
        super(message, cause);
    }
}