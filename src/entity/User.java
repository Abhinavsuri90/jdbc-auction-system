package entity;

import java.sql.Timestamp;

public class User {
    private int userId;
    private String email;
    private String phone;
    private String firstName;
    private String lastName;
    private String kycStatus;
    private Timestamp kycVerifiedAt;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public User(int userId, String email, String phone, String firstName, String lastName, String kycStatus,
                Timestamp kycVerifiedAt, Timestamp createdAt, Timestamp updatedAt) {
        this.userId = userId;
        this.email = email;
        this.phone = phone;
        this.firstName = firstName;
        this.lastName = lastName;
        this.kycStatus = kycStatus;
        this.kycVerifiedAt = kycVerifiedAt;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public int getUserId() {
        return userId;
    }

    public String getEmail() {
        return email;
    }

    public String getPhone() {
        return phone;
    }

    public String getFirstName() {
        return firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public String getKycStatus() {
        return kycStatus;
    }

    public Timestamp getKycVerifiedAt() {
        return kycVerifiedAt;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
}