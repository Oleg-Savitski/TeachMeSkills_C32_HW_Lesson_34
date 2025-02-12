package com.teachmeskills.lesson_34.e_library_app.exception;

public class ReservationDAOException extends Exception {
  public ReservationDAOException(String message) {
    super(message);
  }

  public ReservationDAOException(String message, Throwable cause) {
    super(message, cause);
  }
}