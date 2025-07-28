
import DAO.UserDAO;
import db.DBConnector;
import entity.User;

import java.sql.*;

public class Main {
    public static void main(String[] args) {
        // Set up database connection credentials
        System.out.println("=== Database Connection Setup ===");
        DBConnector.setDatabaseCredentials();
        System.out.println();
        
        //inserting user using jdbc
        User user = new User(78, "abhinavsuri@email.com", "+1-525-1501", "Abhinav", "Suri", "verified" , Timestamp.valueOf("2025-06-01 10:00:00"), Timestamp.valueOf("2025-06-01 10:00:00"), Timestamp.valueOf("2025-06-01 10:00:00"));
        UserDAO userDao = new UserDAO();
        userDao.insert(user);


        //implementing frequent queries
        //frequent query:1
        //1. Retrieve the current highest bid per item.
        try {

            Connection connection = DBConnector.getConnection();
            String query1 = "SELECT \n" +
                            "b.item_id,\n" +
                            "MAX(b.amount) AS highest_bid\n" +
                            "FROM \n" +
                            "bids b\n" +
                            "GROUP BY \n" +
                            "b.item_id;";
            PreparedStatement preparedStatement = connection.prepareStatement(query1);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                System.out.println("Query1: ");
                while (resultSet.next()) {
                    int item_id = resultSet.getInt("item_id");
                    int highest_bid = resultSet.getInt("highest_bid");

                    System.out.println("Item ID: " + item_id);
                    System.out.println("Highest bid: " + highest_bid);
                    System.out.println();
                }

            } catch (Exception e) {
                System.out.println(e.getMessage());
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }

        //frequent query:2
        //2. List all active auctions ending within 1 hour
        try {
            Connection connection = DBConnector.getConnection();
            String query2 = "SELECT auction_id, auction_name, start_time,  end_time,  status \n" +
                            "FROM auctions\n" +
                            "WHERE \n" +
                            "status = 'ongoing'\n" +
                            "AND end_time BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL 1 HOUR);\n";
            PreparedStatement preparedStatement = connection.prepareStatement(query2);

            try(ResultSet resultSet = preparedStatement.executeQuery()) {
                System.out.println("Query2: ");
                while(resultSet.next()) {
                    int auction_id = resultSet.getInt("auction_id");
                    String auction_name = resultSet.getString("auction_name");
                    Timestamp start_time = resultSet.getTimestamp("start_time");
                    Timestamp end_time = resultSet.getTimestamp("end_time");
                    String status = resultSet.getString("status");

                    System.out.println("Auction id: " + auction_id);
                    System.out.println("Auction name: " + auction_name);
                    System.out.println("start time: " + start_time);
                    System.out.println("end time: " + end_time);
                    System.out.println("Status: " + status);
                    System.out.println();
                }

            } catch (SQLException e) {
                System.out.println(e.getMessage());
            } } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        //frequent query:3
        // Find winning bidders for completed auctions.
        try {
            Connection connection = DBConnector.getConnection();
            String query3 = "SELECT \n" +
                    "a.auction_id, a.auction_name, i.item_id, i.item_name,\n" +
                    "u.user_id AS winning_bidder_id, u.first_name, u.last_name,\n" +
                    "b.amount AS winning_bid_amount, wb.created_at AS winning_time\n" +
                    "FROM \n" +
                    "    auctions a\n" +
                    "JOIN items i ON a.auction_id = i.auction_id\n" +
                    "JOIN winning_bids wb ON i.item_id = wb.item_id\n" +
                    "JOIN bids b ON wb.bid_id = b.bid_id\n" +
                    "JOIN users u ON b.bidder_id = u.user_id\n" +
                    "WHERE \n" +
                    " a.status = 'completed';";
            PreparedStatement preparedStatement = connection.prepareStatement(query3);

            try(ResultSet resultSet = preparedStatement.executeQuery()) {
                System.out.println("Query3: ");
                while(resultSet.next()) {
                    int auctionId = resultSet.getInt("auction_id");
                    String auctionName = resultSet.getString("auction_name");
                    int itemId = resultSet.getInt("item_id");
                    String itemName = resultSet.getString("item_name");
                    int bidderId = resultSet.getInt("winning_bidder_id");
                    String firstName = resultSet.getString("first_name");
                    String lastName = resultSet.getString("last_name");
                    double winningAmount = resultSet.getDouble("winning_bid_amount");
                    Timestamp winningTime = resultSet.getTimestamp("winning_time");

                    System.out.println("Auction ID: " + auctionId);
                    System.out.println("Auction Name: " + auctionName);
                    System.out.println("Item ID: " + itemId);
                    System.out.println("Item Name: " + itemName);
                    System.out.println("Winning Bidder ID: " + bidderId);
                    System.out.println("Bidder Name: " + firstName + " " + lastName);
                    System.out.println("Winning Bid Amount: " + winningAmount);
                    System.out.println("Winning Time: " + winningTime);
                    System.out.println();
                }

            } catch (SQLException e) {
                System.out.println(e.getMessage());
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        //frequent query:4
        //Show bidding history for a specific item.
        try {
            Connection connection = DBConnector.getConnection();
            String query4 = "SELECT \n" +
                    "b.bid_id,b.item_id,u.user_id AS bidder_id,\n" +
                    "u.first_name,u.last_name,b.amount AS bid_amount,\n" +
                    "b.timestamp\n" +
                    "FROM \n" +
                    "bids b\n" +
                    "JOIN users u ON b.bidder_id=u.user_id\n" +
                    "WHERE \n" +
                    "b.item_id=?\n" +
                    "ORDER BY \n" +
                    "b.timestamp ASC;\n";
            PreparedStatement preparedStatement = connection.prepareStatement(query4);
            preparedStatement.setInt(1, 1);

            try(ResultSet resultSet = preparedStatement.executeQuery()) {
                System.out.println("Query 4:");
                while(resultSet.next()) {
                    int bidId = resultSet.getInt("bid_id");
                    int itemId = resultSet.getInt("item_id");
                    int bidderId = resultSet.getInt("bidder_id");
                    String firstName = resultSet.getString("first_name");
                    String lastName = resultSet.getString("last_name");
                    double bidAmount = resultSet.getDouble("bid_amount");
                    Timestamp timestamp = resultSet.getTimestamp("timestamp");

                    System.out.println("Bid ID: " + bidId);
                    System.out.println("Item ID: " + itemId);
                    System.out.println("Bidder ID: " + bidderId);
                    System.out.println("Bidder Name: " + firstName + " " + lastName);
                    System.out.println("Bid Amount: " + bidAmount);
                    System.out.println("Bid Time: " + timestamp);
                    System.out.println();
                }

            } catch (SQLException e) {
                System.out.println(e.getMessage());
            }

        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        //frequent query:5
        //5. Compute total bids placed by a user in a period.
        try {
            Connection connection = DBConnector.getConnection();
            String query5 = "SELECT \n" +
                    "    b.bidder_id,COUNT(*) AS total_bids,MIN(b.timestamp) AS first_bid_time,\n" +
                    "    MAX(b.timestamp) AS last_bid_time,SUM(b.amount) AS total_bid_amount,\n" +
                    "    u.first_name,u.last_name\n" +
                    "FROM \n" +
                    "    bids b\n" +
                    "JOIN users u ON b.bidder_id=u.user_id\n" +
                    "WHERE \n" +
                    "    b.bidder_id=? AND \n" +
                    "    b.timestamp BETWEEN ? AND ?\n" +
                    "GROUP BY \n" +
                    "    b.bidder_id,u.first_name,u.last_name;\n";
            PreparedStatement preparedStatement = connection.prepareStatement(query5);
            preparedStatement.setInt(1, 3);
            preparedStatement.setTimestamp(2 ,Timestamp.valueOf("2025-06-22 09:30:00"));
            preparedStatement.setTimestamp(3 ,Timestamp.valueOf("2025-06-22 10:30:00"));

            try(ResultSet resultSet = preparedStatement.executeQuery()) {
                System.out.println("Query 5:");
                while(resultSet.next()) {
                    int bidderId = resultSet.getInt("bidder_id");
                    int totalBids = resultSet.getInt("total_bids");
                    Timestamp firstBidTime = resultSet.getTimestamp("first_bid_time");
                    Timestamp lastBidTime = resultSet.getTimestamp("last_bid_time");
                    double totalBidAmount = resultSet.getDouble("total_bid_amount");
                    String firstName = resultSet.getString("first_name");
                    String lastName = resultSet.getString("last_name");

                    System.out.println("Bidder ID: " + bidderId);
                    System.out.println("Bidder Name: " + firstName + " " + lastName);
                    System.out.println("Total Bids: " + totalBids);
                    System.out.println("Total Bid Amount: " + totalBidAmount);
                    System.out.println("First Bid Time: " + firstBidTime);
                    System.out.println("Last Bid Time: " + lastBidTime);
                    System.out.println();
                }

            } catch (SQLException e) {
                System.out.println(e.getMessage());
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }


    }
}