package entity;
import java.sql.Timestamp;

public class Bids {
    private int bidId;
    private int itemId;
    private int bidderId;
    private double amount;
    private Timestamp timestamp;

    public Bids(int bidId, int itemId, int bidderId, Timestamp timestamp, double amount) {
        this.bidId = bidId;
        this.itemId = itemId;
        this.bidderId = bidderId;
        this.timestamp = timestamp;
        this.amount = amount;
    }

    public int getBidId() {
        return bidId;
    }

    public int getItemId() {
        return itemId;
    }

    public int getBidderId() {
        return bidderId;
    }

    public double getAmount() {
        return amount;
    }

    public Timestamp getTimestamp() {
        return timestamp;
    }
}