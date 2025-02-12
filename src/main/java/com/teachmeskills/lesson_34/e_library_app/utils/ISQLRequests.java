package com.teachmeskills.lesson_34.e_library_app.utils;

public interface ISQLRequests {
    String INSERT_BOOKS = "INSERT INTO books (title, author, publication_year) VALUES (?, ?, ?)";
    String SELECT_BOOKS = "SELECT * FROM books WHERE id = ?";
    String SELECT_FUNCTION_GET = "SELECT * FROM get_all_books()";
    String INSERT_RESERVATION = "INSERT INTO reservations (book_id, username_id, reservation_date, return_date) VALUES (?, ?, ?, ?)";
    String SELECT_RESERVATION = "SELECT * FROM reservations WHERE id = ?";
    String SELECT_FUNCTION_RESERVATION = "SELECT * FROM get_last_borrowed_book()";
    String INSERT_USER = "INSERT INTO users (username, email) VALUES (?, ?)";
    String SELECT_USER = "SELECT * FROM users WHERE id = ?";
    String SELECT_FUNCTION_USER = "SELECT get_last_registered_user() AS username";
}
