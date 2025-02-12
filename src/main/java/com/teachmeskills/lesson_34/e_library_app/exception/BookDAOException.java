package com.teachmeskills.lesson_34.e_library_app.exception;

public class BookDAOException extends Exception {
    public BookDAOException(String message) {
        super(message);
    }

    public BookDAOException(String message, Throwable cause) {
        super(message, cause);
    }
}