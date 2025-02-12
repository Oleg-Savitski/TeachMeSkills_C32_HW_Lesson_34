package com.teachmeskills.lesson_34.e_library_app.utils;

import java.io.FileInputStream;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

public final class DatabaseConfig {
    private static final Logger logger = Logger.getLogger(DatabaseConfig.class.getName());
    private static volatile DatabaseConfig instance;
    private String url;
    private String user;
    private String password;

    private DatabaseConfig() {
        loadProperties();
    }

    public static DatabaseConfig getInstance() {
        if (instance == null) {
            synchronized (DatabaseConfig.class) {
                if (instance == null) {
                    instance = new DatabaseConfig();
                }
            }
        }
        return instance;
    }

    private void loadProperties() {
        try (InputStream input = new FileInputStream("src/main/resources/database_config.properties")) {
            Properties prop = new Properties();
            prop.load(input);
            url = prop.getProperty("db.url");
            user = prop.getProperty("db.user");
            password = prop.getProperty("db.password");
        } catch (Exception ex) {
            logger.log(Level.SEVERE, "Error when uploading the configuration file -> " + ex.getMessage(), ex);
        }
    }

    public Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, user, password);
    }

    public String getUser () {
        return user;
    }

    public String getPassword() {
        return password;
    }

    public String getUrl() {
        return url;
    }
}