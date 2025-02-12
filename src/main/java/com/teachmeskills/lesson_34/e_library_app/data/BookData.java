package com.teachmeskills.lesson_34.e_library_app.data;

import com.teachmeskills.lesson_34.e_library_app.exception.BookDAOException;
import com.teachmeskills.lesson_34.e_library_app.model.Book;
import com.teachmeskills.lesson_34.e_library_app.utils.DatabaseConfig;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import static com.teachmeskills.lesson_34.e_library_app.utils.ISQLRequests.*;

public class BookData {
    private static final Logger logger = Logger.getLogger(BookData.class.getName());

    public void addBook(Book book) throws BookDAOException {
        try (Connection conn = DatabaseConfig.getInstance().getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement preparedStatement = conn.prepareStatement(INSERT_BOOKS)) {
                preparedStatement.setString(1, book.getTitle());
                preparedStatement.setString(2, book.getAuthor());
                preparedStatement.setInt(3, book.getPublicationYear());
                preparedStatement.executeUpdate();
                logger.log(Level.INFO, "Book added -> " + book.getTitle());
                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                logger.log(Level.SEVERE, "Error adding book -> " + book.getTitle(), e);
                throw new BookDAOException("Error adding book -> " + book.getTitle(), e);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Database connection error", e);
            throw new BookDAOException("Database connection error", e);
        }
    }

    public Book getBookById(long id) throws BookDAOException {
        try (Connection conn = DatabaseConfig.getInstance().getConnection()) {
            try (PreparedStatement preparedStatement = conn.prepareStatement(SELECT_BOOKS)) {
                preparedStatement.setLong(1, id);
                ResultSet rs = preparedStatement.executeQuery();
                if (rs.next()) {
                    return new Book(rs.getLong("id"), rs.getString("title"), rs.getString("author"), rs.getInt("publication_year"));
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error retrieving book with ID -> " + id, e);
            throw new BookDAOException("Error retrieving book with ID -> " + id, e);
        }
        return null;
    }

    public List<Book> getAllBooks() throws BookDAOException {
        List<Book> books = new ArrayList<>();
                try (Connection conn = DatabaseConfig.getInstance().getConnection();
             PreparedStatement preparedStatement = conn.prepareStatement(SELECT_FUNCTION_GET);
             ResultSet rs = preparedStatement.executeQuery()) {

            while (rs.next()) {
                Book book = new Book(
                        rs.getLong("id"),
                        rs.getString("title"),
                        rs.getString("author"),
                        rs.getInt("publication_year")
                );
                books.add(book);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error retrieving all books", e);
            throw new BookDAOException("Error retrieving all books", e);
        }

        return books;
    }
}