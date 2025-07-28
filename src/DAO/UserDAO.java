
package DAO;

import db.DBConnector;
import entity.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class UserDAO {
    private static final String query = "INSERT INTO users(userId, email,  phone, first_name , last_name , kycStatus , kyc_verified_at , created_at , updated_at ) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)";

    public void insert(User user) {
        try {
            Connection connection = DBConnector.getConnection();
            PreparedStatement ps = connection.prepareStatement(query);

            ps.setInt(1, user.getUserId());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getFirstName());
            ps.setString(5, user.getLastName());
            ps.setString(6, user.getKycStatus());
            ps.setTimestamp(7, user.getKycVerifiedAt());
            ps.setTimestamp(7, user.getCreatedAt());
            ps.setTimestamp(7, user.getUpdatedAt());
            ps.executeUpdate();
        } catch(SQLException e) {
            System.out.println(e.getMessage());
        }
    }
}