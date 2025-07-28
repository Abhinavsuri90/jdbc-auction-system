package entity;

import java.sql.Timestamp;

public class Wallets {
    private int walletId;
    private int userId;
    private double balance;
    private String status;
    private java.sql.Timestamp createdAt;

    public Wallets(int walletId, int userId, double balance, String status, Timestamp createdAt) {
        this.walletId = walletId;
        this.userId = userId;
        this.balance = balance;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getWalletId() {
        return walletId;
    }

    public int getUserId() {
        return userId;
    }

    public double getBalance() {
        return balance;
    }

    public String getStatus() {
        return status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }
}