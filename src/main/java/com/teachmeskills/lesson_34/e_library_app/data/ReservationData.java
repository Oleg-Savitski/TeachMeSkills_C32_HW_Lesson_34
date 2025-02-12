package com.teachmeskills.lesson_34.e_library_app.data;

import com.teachmeskills.lesson_34.e_library_app.exception.ReservationDAOException;
import com.teachmeskills.lesson_34.e_library_app.model.Reservation;
import com.teachmeskills.lesson_34.e_library_app.utils.DatabaseConfig;

import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

import static com.teachmeskills.lesson_34.e_library_app.utils.ISQLRequests.*;

public class ReservationData {
    private static final Logger logger = Logger.getLogger(ReservationData.class.getName());

    public void addReservation(Reservation reservation) throws ReservationDAOException {
        logger.log(Level.INFO, "Attempting to add reservation: " + reservation.toString());
        try (Connection conn = DatabaseConfig.getInstance().getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement preparedStatement = conn.prepareStatement(INSERT_RESERVATION)) {
                preparedStatement.setLong(1, reservation.getBookId());
                preparedStatement.setLong(2, reservation.getUsernameId());
                preparedStatement.setDate(3, (Date) reservation.getReservationDate());
                preparedStatement.setDate(4, (Date) reservation.getReturnDate());
                preparedStatement.executeUpdate();
                logger.log(Level.INFO, "Reservation added for book ID -> " + reservation.getBookId());
                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                logger.log(Level.SEVERE, "Error adding reservation for book ID -> " + reservation.getBookId(), e);
                throw new ReservationDAOException("Error adding reservation for book ID -> " + reservation.getBookId(), e);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Database connection error", e);
            throw new ReservationDAOException("Database connection error", e);
        }
    }

    public Reservation getReservationById(long id) throws ReservationDAOException {
                try (Connection conn = DatabaseConfig.getInstance().getConnection()) {
            try (PreparedStatement preparedStatement = conn.prepareStatement(SELECT_RESERVATION)) {
                preparedStatement.setLong(1, id);
                ResultSet rs = preparedStatement.executeQuery();
                if (rs.next()) {
                    return new Reservation(rs.getLong("id"), rs.getLong("book_id"), rs.getLong("username_id"), rs.getDate("reservation_date"), rs.getDate("return_date"));
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error retrieving reservation with ID -> " + id, e);
            throw new ReservationDAOException("Error retrieving reservation with ID -> " + id, e);
        }
        return null;
    }

    public String getLastBorrowedBook() throws ReservationDAOException {
        try (Connection conn = DatabaseConfig.getInstance().getConnection();
             PreparedStatement preparedStatement = conn.prepareStatement(SELECT_FUNCTION_RESERVATION);
             ResultSet rs = preparedStatement.executeQuery()) {

            if (rs.next()) {
                String bookTitle = rs.getString("book_title");
                int publicationYear = rs.getInt("publication_year");
                String username = rs.getString("username");

                if (bookTitle != null) {
                    return "Last borrowed book -> " + bookTitle + ", Year -> " + publicationYear + ", Borrowed by -> " + username;
                } else {
                    return "No books borrowed";
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error retrieving last borrowed book", e);
            throw new ReservationDAOException("Error retrieving last borrowed book", e);
        }
        return "No books borrowed";
    }
}