package DAO;

import db.DBConnector;
import entity.Bids;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class BidsDAO {
    private static String query = "INSERT INTO bids (bid_id, item_id, bidder_id, timestamp, amount) VALUES (?, ?, ?, ?, ?)";
    public void insert(Bids bid) {
        try {
            Connection connection = DBConnector.getConnection();
            PreparedStatement ps = connection.prepareStatement(query);
            ps.setInt(1, bid.getBidId());
            ps.setInt(2, bid.getItemId());
            ps.setInt(3, bid.getBidderId());
            ps.setTimestamp(4, bid.getTimestamp());
            ps.setDouble(5, bid.getAmount());
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }
}