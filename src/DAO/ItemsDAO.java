
package DAO;

import db.DBConnector;
import entity.Items;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class ItemsDAO {
    private static final String query = "INSERT INTO items(itemId, itemName, description, startPrice, reservePrice, sellerId, auctionId, status, listingFee, resHideFee, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    public void insert(Items item) {
        if (item == null) {
            System.err.println("❌ Cannot insert null item");
            return;
        }
        
        try {
            Connection connection = DBConnector.getConnection();
            if (connection == null) {
                System.err.println("❌ Failed to get database connection");
                return;
            }
            
            PreparedStatement ps = connection.prepareStatement(query);

            ps.setInt(1, item.getItemId());
            ps.setString(2, item.getItemName());
            ps.setString(3, item.getDescription());
            ps.setDouble(4, item.getStartPrice());
            ps.setDouble(5, item.getReservePrice());
            ps.setInt(6, item.getSellerId());
            ps.setInt(7, item.getAuctionId());
            ps.setString(8, item.getStatus());
            ps.setDouble(9, item.getListingFee());
            ps.setDouble(10, item.getResHideFee());
            ps.setTimestamp(11, item.getCreatedAt());
            ps.setTimestamp(12, item.getUpdatedAt());

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("✅ Item '" + item.getItemName() + "' inserted successfully!");
            } else {
                System.out.println("⚠️ No rows were affected during item insertion");
            }
            
            ps.close();
            connection.close();
        } catch (SQLException e) {
            System.err.println("❌ Error inserting item: " + e.getMessage());
        }
    }
}