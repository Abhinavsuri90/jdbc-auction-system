package db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Scanner;

public class DBConnector {
    private static String url;
    private static String user;
    private static String password;
    private static boolean credentialsSet = false;

    // Alternative method to set credentials programmatically
    public static void setDatabaseCredentials(String host, String port, String dbName, String username, String pwd) {
        url = "jdbc:mysql://" + host + ":" + port + "/" + dbName;
        user = username;
        password = pwd;
        credentialsSet = true;
        System.out.println("Database credentials set programmatically!");
        System.out.println("Connection URL: " + url);
    }

    @SuppressWarnings("resource") // Scanner not closed to avoid closing System.in
    public static void setDatabaseCredentials() {
        Scanner scanner = new Scanner(System.in);
        
        try {
            System.out.print("Enter database host (e.g., localhost or 127.0.0.1): ");
            String host = scanner.nextLine().trim();
            if (host.isEmpty()) {
                host = "127.0.0.1"; // default
            }
            
            System.out.print("Enter database port (default 3306): ");
            String portInput = scanner.nextLine().trim();
            String port = portInput.isEmpty() ? "3306" : portInput;
            
            System.out.print("Enter database name: ");
            String dbName = scanner.nextLine().trim();
            
            System.out.print("Enter database username: ");
            user = scanner.nextLine().trim();
            
            System.out.print("Enter database password: ");
            password = scanner.nextLine();
            
            url = "jdbc:mysql://" + host + ":" + port + "/" + dbName;
            credentialsSet = true;
            
            System.out.println("Database credentials set successfully!");
            System.out.println("Connection URL: " + url);
        } finally {
            // Note: We don't close scanner here as it closes System.in
            // which would prevent further input in the program
        }
    }

    public static Connection getConnection() {
        if (!credentialsSet) {
            System.out.println("Database credentials not set. Please provide connection details:");
            setDatabaseCredentials();
        }
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(url, user, password);
        } catch (ClassNotFoundException | SQLException e) {
            System.out.println("Connection failed: " + e.getMessage());
            return null;
        }
    }
}