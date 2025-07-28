
package entity;

import java.sql.Timestamp;

public class Items {
    private int itemId;
    private String itemName;
    private String description;
    private double startPrice;
    private double reservePrice;
    private int sellerId;
    private int auctionId;
    private String status;
    private double listingFee;
    private double resHideFee;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Items(int itemId, String itemName, String description, double startPrice, double reservePrice, int sellerId, int auctionId, String status, double listingFee, double resHideFee, Timestamp createdAt, Timestamp updatedAt) {
        this.itemId = itemId;
        this.itemName = itemName;
        this.description = description;
        this.startPrice = startPrice;
        this.reservePrice = reservePrice;
        this.sellerId = sellerId;
        this.auctionId = auctionId;
        this.status = status;
        this.listingFee = listingFee;
        this.resHideFee = resHideFee;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public int getItemId() {
        return itemId;
    }

    public String getItemName() {
        return itemName;
    }

    public String getDescription() {
        return description;
    }

    public double getStartPrice() {
        return startPrice;
    }

    public double getReservePrice() {
        return reservePrice;
    }

    public int getSellerId() {
        return sellerId;
    }

    public int getAuctionId() {
        return auctionId;
    }

    public String getStatus() {
        return status;
    }

    public double getListingFee() {
        return listingFee;
    }

    public double getResHideFee() {
        return resHideFee;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
}
