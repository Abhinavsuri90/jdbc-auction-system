package DAO;

import db.DBConnector;
import entity.Wallets;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class WalletsDAO {
    private static final String query = "INSERT INTO wallets (wallet_id, user_id, balance, status, created_at) VALUES (?, ?, ?, ?, ?)";

    public void insert(Wallets wallet) {
        try {
            Connection connection = DBConnector.getConnection();
            PreparedStatement ps = connection.prepareStatement(query);


            ps.setInt(1, wallet.getWalletId());
            ps.setInt(2, wallet.getUserId());
            ps.setDouble(3, wallet.getBalance());
            ps.setString(4, wallet.getStatus());
            ps.setTimestamp(5, wallet.getCreatedAt());
            ps.executeUpdate();
            ps.executeUpdate();
        } catch(SQLException e) {
            System.out.println(e.getMessage());
        }
    }
}