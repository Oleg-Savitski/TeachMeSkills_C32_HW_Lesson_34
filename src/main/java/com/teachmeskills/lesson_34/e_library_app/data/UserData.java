package com.teachmeskills.lesson_34.e_library_app.data;

import com.teachmeskills.lesson_34.e_library_app.exception.UserDAOException;
import com.teachmeskills.lesson_34.e_library_app.model.User;
import com.teachmeskills.lesson_34.e_library_app.utils.DatabaseConfig;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

import static com.teachmeskills.lesson_34.e_library_app.utils.ISQLRequests.*;

public class UserData {
    private static final Logger logger = Logger.getLogger(UserData.class.getName());

    public void addUser (User user) throws UserDAOException {
        try (Connection conn = DatabaseConfig.getInstance().getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement preparedStatement = conn.prepareStatement(INSERT_USER)) {
                preparedStatement.setString(1, user.getUsername());
                preparedStatement.setString(2, user.getEmail());
                preparedStatement.executeUpdate();
                logger.log(Level.INFO, "User  added -> " + user.getUsername());
                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                logger.log(Level.SEVERE, "Error adding user -> " + user.getUsername(), e);
                throw new UserDAOException("Error adding user -> " + user.getUsername(), e);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Database connection error", e);
            throw new UserDAOException("Database connection error", e);
        }
    }

    public User getUserById(long id) throws UserDAOException {
        try (Connection conn = DatabaseConfig.getInstance().getConnection()) {
            try (PreparedStatement preparedStatement = conn.prepareStatement(SELECT_USER)) {
                preparedStatement.setLong(1, id);
                ResultSet rs = preparedStatement.executeQuery();
                if (rs.next()) {
                    return new User(rs.getLong("id"), rs.getString("username"), rs.getString("email"));
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error retrieving user with ID -> " + id, e);
            throw new UserDAOException("Error retrieving user with ID -> " + id, e);
        }
        return null;
    }

    public String getLastRegisteredUser () throws UserDAOException {
        try (Connection conn = DatabaseConfig.getInstance().getConnection()) {
            try (PreparedStatement preparedStatement = conn.prepareStatement(SELECT_FUNCTION_USER);
                 ResultSet rs = preparedStatement.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("username");
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error retrieving last registered user", e);
            throw new UserDAOException("Error retrieving last registered user", e);
        }
        return null;
    }
}