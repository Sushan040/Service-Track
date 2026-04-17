package com.servicetrack.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // Update these with your MySQL credentials
    private static final String URL = "jdbc:mysql://localhost:3306/servicetrack_db?useSSL=false&allowPublicKeyRetrieval=true";
    private static final String USERNAME = "root";  // Change to your MySQL username
    private static final String PASSWORD = "";      // Change to your MySQL password
    
    private static Connection connection = null;
    
    private DBConnection() {}
    
    public static Connection getConnection() {
        try {
            if (connection == null || connection.isClosed()) {
                Class.forName("com.mysql.cj.jdbc.Driver");
                connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
                System.out.println("Database connected successfully!");
            }
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found!");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Failed to connect to database!");
            e.printStackTrace();
        }
        return connection;
    }
    
    public static void closeConnection() {
        if (connection != null) {
            try {
                if (!connection.isClosed()) {
                    connection.close();
                    System.out.println("Database connection closed.");
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            connection = null;
        }
    }
}