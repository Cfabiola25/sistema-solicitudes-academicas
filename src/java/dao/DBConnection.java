package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Utility class for obtaining database connections. The
 * configuration parameters (URL, user and password) are
 * declared as constants for simplicity. Adjust these values
 * according to your local MySQL installation. The project
 * assumes the MySQL JDBC driver is available on the
 * classpath (e.g. mysql-connector-j). In NetBeans you can
 * add the driver as a library to the project.
 */
public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/fesc_solicitudes?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=America/Bogota";
    private static final String USER = "root";
    private static final String PASSWORD = "Nelis2508"; 

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC Driver not found. Please add it to your project.", e);
        }
    }

    /**
     * Returns a new database connection. It is the caller's
     * responsibility to close the connection when it is no
     * longer needed.
     *
     * @return a new Connection
     * @throws SQLException if a connection cannot be established
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}