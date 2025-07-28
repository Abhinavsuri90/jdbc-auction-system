CREATE DATABASE SCHEMA_SIR;
USE SCHEMA_SIR;

-- -------------------------
-- 1. Users Table
-- -------------------------
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(15) NOT NULL UNIQUE,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    kyc_status ENUM('pending', 'verified', 'rejected') DEFAULT 'pending',
    kyc_verified_at DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- -------------------------
-- 2. Wallets Table
-- -------------------------
CREATE TABLE wallets (
    wallet_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNIQUE,
    balance DECIMAL(12,2) DEFAULT 0.00,
    status ENUM('active', 'blocked', 'suspended') DEFAULT 'active',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- -------------------------
-- 3. Bank Accounts Table
-- -------------------------
CREATE TABLE bank_accounts (
    bank_account_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    account_number VARCHAR(30) NOT NULL,
    ifsc_code VARCHAR(15),
    bank_name VARCHAR(100),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- -------------------------
-- 4. Auctions Table
-- -------------------------
CREATE TABLE auctions (
    auction_id INT AUTO_INCREMENT PRIMARY KEY,
    auction_name VARCHAR(255),
    start_time DATETIME,
    end_time DATETIME,
    status ENUM('scheduled', 'ongoing', 'completed') DEFAULT 'scheduled',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_active_auctions (end_time, status)  -- ✅ To quickly find auctions closing soon and still active
);

-- -------------------------
-- 5. Items Table
-- -------------------------
CREATE TABLE items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    item_name VARCHAR(255),
    description TEXT,
    start_price DECIMAL(12,2),
    reserve_price DECIMAL(12,2),
    seller_id INT,
    auction_id INT,
    status ENUM('unsold', 'sold') DEFAULT 'unsold',
    listing_fee DECIMAL(12,2),
    res_hide_fee DECIMAL(12,2),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (seller_id) REFERENCES users(user_id),
    FOREIGN KEY (auction_id) REFERENCES auctions(auction_id),
    INDEX idx_items_by_auction (auction_id),
    INDEX idx_items_by_seller (seller_id)
);

-- -------------------------
-- 6. Bids Table
-- -------------------------
CREATE TABLE bids (
    bid_id INT AUTO_INCREMENT PRIMARY KEY,
    item_id INT,
    bidder_id INT,
    amount DECIMAL(12,2),
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (item_id) REFERENCES items(item_id),
    FOREIGN KEY (bidder_id) REFERENCES users(user_id),
    INDEX idx_highest_bid_per_item (item_id, timestamp DESC), -- ✅ For quickly fetching current highest bid
    INDEX idx_user_bids (bidder_id, timestamp)              -- ✅ For user’s total bids in a period
);

-- -------------------------
-- 7. Winning Bids Table
-- -------------------------
CREATE TABLE winning_bids (
    win_id INT AUTO_INCREMENT PRIMARY KEY,
    item_id INT UNIQUE,
    bid_id INT,
    conversion_fee DECIMAL(12,2),
    transaction_fee DECIMAL(12,2),
    payment_status ENUM('pending', 'paid', 'failed') DEFAULT 'pending',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (item_id) REFERENCES items(item_id),
    FOREIGN KEY (bid_id) REFERENCES bids(bid_id),
    INDEX idx_winner_auction (item_id)  -- ✅ For querying winners per item/auction
);

-- -------------------------
-- 8. Wallet Transactions
-- -------------------------
CREATE TABLE wallet_transactions (
    wallet_transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    from_wallet_id INT,
    to_wallet_id INT,
    amount DECIMAL(12,2),
    transaction_type ENUM('charges', 'transfer', 'refund') NOT NULL,
    transaction_status ENUM('pending', 'completed', 'failed') DEFAULT 'completed',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (from_wallet_id) REFERENCES wallets(wallet_id),
    FOREIGN KEY (to_wallet_id) REFERENCES wallets(wallet_id),
    INDEX idx_wallet_transactions_by_type (transaction_type)
);

-- -------------------------
-- 9. Account Transactions
-- -------------------------
CREATE TABLE account_transactions (
    account_transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    wallet_id INT,
    bank_account_id INT,
    amount DECIMAL(12,2),
    transaction_type ENUM('withdrawal', 'deposit') NOT NULL,
    transaction_status ENUM('pending', 'completed', 'failed') DEFAULT 'completed',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (wallet_id) REFERENCES wallets(wallet_id),
    FOREIGN KEY (bank_account_id) REFERENCES bank_accounts(bank_account_id),
    INDEX idx_account_transactions_by_type (transaction_type)
);

-- -------------------------
-- 10. Wallet Transaction Breakdown
-- -------------------------
CREATE TABLE wallet_transaction_breakdowns (
    breakdown_id INT AUTO_INCREMENT PRIMARY KEY,
    wallet_transaction_id INT,
    amount DECIMAL(12,2),
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (wallet_transaction_id) REFERENCES wallet_transactions(wallet_transaction_id)
);

-- -------------------------
-- 11. Account Transaction Breakdown
-- -------------------------
CREATE TABLE account_transaction_breakdowns (
    breakdown_id INT AUTO_INCREMENT PRIMARY KEY,
    account_transaction_id INT,
    amount DECIMAL(12,2),
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (account_transaction_id) REFERENCES account_transactions(account_transaction_id)
);

-- -------------------------
-- 12. Bid Audit Log Table
-- -------------------------
CREATE TABLE bid_audit_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    bid_id INT,
    item_id INT,
    user_id INT,
    action ENUM('placed', 'updated', 'withdrawn'),
    details TEXT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (bid_id) REFERENCES bids(bid_id),
    FOREIGN KEY (item_id) REFERENCES items(item_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    INDEX idx_audit_log_by_item (item_id)
);


INSERT INTO users (user_id, email, phone, first_name, last_name, kyc_status, kyc_verified_at, created_at, updated_at)
VALUES
  (6, 'frank@example.com', '9000000006', 'Frank', 'Bidder', 'verified', '2025-06-02 10:00:00', '2025-06-02 10:00:00', '2025-06-02 10:00:00'),
  (7, 'grace@example.com', '9000000007', 'Grace', 'Seller', 'verified', '2025-06-02 11:00:00', '2025-06-02 11:00:00', '2025-06-02 11:00:00'),
  (8, 'heidi@example.com', '9000000008', 'Heidi', 'Bidder', 'pending', NULL, '2025-06-02 12:00:00', '2025-06-02 12:00:00'),
  (9, 'ivan@example.com', '9000000009', 'Ivan', 'Bidder', 'verified', '2025-06-02 13:00:00', '2025-06-02 13:00:00', '2025-06-02 13:00:00'),
  (10, 'judy@example.com', '9000000010', 'Judy', 'Seller', 'verified', '2025-06-02 14:00:00', '2025-06-02 14:00:00', '2025-06-02 14:00:00');

SELECT *
from users;


-- USERS
INSERT INTO users (user_id, email, phone, first_name, last_name, kyc_status, kyc_verified_at, created_at, updated_at) VALUES
  (1, 'alice@example.com', '9000000001', 'Alice', 'Seller', 'verified', '2025-06-01 10:00:00', '2025-06-01 10:00:00', '2025-06-01 10:00:00'),
  (2, 'bob@example.com', '9000000002', 'Bob', 'Bidder', 'verified', '2025-06-01 11:00:00', '2025-06-01 11:00:00', '2025-06-01 11:00:00'),
  (3, 'carol@example.com', '9000000003', 'Carol', 'Bidder', 'verified', '2025-06-01 12:00:00', '2025-06-01 12:00:00', '2025-06-01 12:00:00'),
  (4, 'dan@example.com', '9000000004', 'Dan', 'Bidder', 'pending', NULL, '2025-06-01 13:00:00', '2025-06-01 13:00:00'),
  (5, 'eve@example.com', '9000000005', 'Eve', 'Seller', 'verified', '2025-06-01 14:00:00', '2025-06-01 14:00:00', '2025-06-01 14:00:00')
  ;
  

-- WALLETS
INSERT INTO wallets (wallet_id, user_id, balance, status, created_at) VALUES
  (1, 1, 10000.00, 'active', '2025-06-01 10:05:00'),
  (2, 2, 2000.00, 'active', '2025-06-01 11:05:00'),
  (3, 3, 3000.00, 'active', '2025-06-01 12:05:00'),
  (4, 4, 1500.00, 'active', '2025-06-01 13:05:00'),
  (5, 5, 5000.00, 'active', '2025-06-01 14:05:00'),
  (6, 6, 800.00, 'active', '2025-06-02 10:05:00'),
  (7, 7, 12000.00, 'active', '2025-06-02 11:05:00'),
  (8, 8, 0.00, 'blocked', '2025-06-02 12:05:00'),
  (9, 9, 500.00, 'active', '2025-06-02 13:05:00'),
  (10, 10, 7500.00, 'active', '2025-06-02 14:05:00');

-- BANK ACCOUNTS
INSERT INTO bank_accounts (bank_account_id, user_id, account_number, ifsc_code, bank_name, created_at) VALUES
  (1, 1, '1111111111', 'IFSC001', 'Axis Bank', '2025-06-01 10:10:00'),
  (2, 2, '2222222222', 'IFSC002', 'HDFC Bank', '2025-06-01 11:10:00'),
  (3, 3, '3333333333', 'IFSC003', 'SBI', '2025-06-01 12:10:00'),
  (4, 5, '5555555555', 'IFSC005', 'ICICI Bank', '2025-06-01 14:10:00'),
  (5, 6, '6666666666', 'IFSC006', 'Kotak Bank', '2025-06-02 10:10:00'),
  (6, 7, '7777777777', 'IFSC007', 'PNB', '2025-06-02 11:10:00'),
  (7, 10, '1010101010', 'IFSC010', 'Yes Bank', '2025-06-02 14:10:00');

-- AUCTIONS
INSERT INTO auctions (auction_id, auction_name, start_time, end_time, status, created_at) VALUES
  (1, 'Vintage Artifacts', '2025-06-22 09:00:00', '2025-06-22 17:00:00', 'completed', '2025-06-01 10:00:00'),
  (2, 'Rare Coins', '2025-06-22 10:00:00', '2025-06-22 18:00:00', 'ongoing', '2025-06-01 11:00:00'),
  (3, 'Modern Gadgets', '2025-06-22 11:00:00', '2025-06-22 19:00:00', 'scheduled', '2025-06-01 12:00:00'),
  (4, 'Luxury Watches', '2025-06-23 09:00:00', '2025-06-23 15:00:00', 'ongoing', '2025-06-02 10:00:00'),
  (5, 'Classic Cars', '2025-06-23 10:00:00', '2025-06-23 18:00:00', 'scheduled', '2025-06-02 11:00:00'),
  (6, 'Art Masterpieces', '2025-06-23 11:00:00', '2025-06-23 19:00:00', 'completed', '2025-06-02 12:00:00');

-- ITEMS
INSERT INTO items (item_id, item_name, description, start_price, reserve_price, seller_id, auction_id, status, listing_fee, res_hide_fee, created_at, updated_at) VALUES
  (1, 'Antique Vase', 'A beautiful antique vase.', 1000.00, 1500.00, 1, 1, 'sold', 50.00, 10.00, '2025-06-01 10:15:00', '2025-06-22 17:01:00'),
  (2, 'Rare Coin', 'A rare old coin.', 500.00, 800.00, 1, 2, 'unsold', 30.00, 5.00, '2025-06-01 11:15:00', '2025-06-22 18:01:00'),
  (3, 'Smartphone', 'Latest model phone.', 7000.00, 9000.00, 5, 3, 'unsold', 100.00, 20.00, '2025-06-01 14:15:00', '2025-06-22 19:01:00'),
  (4, 'Rolex Watch', 'Luxury men''s watch.', 20000.00, 25000.00, 7, 4, 'unsold', 200.00, 20.00, '2025-06-02 10:15:00', '2025-06-23 15:01:00'),
  (5, 'Vintage Car', 'Classic 1960s car.', 100000.00, 120000.00, 10, 5, 'unsold', 500.00, 50.00, '2025-06-02 11:15:00', '2025-06-23 18:01:00'),
  (6, 'Picasso Painting', 'Original painting.', 500000.00, 600000.00, 7, 6, 'sold', 1000.00, 100.00, '2025-06-02 12:15:00', '2025-06-23 19:01:00');

-- BIDS
INSERT INTO bids (bid_id, item_id, bidder_id, amount, timestamp) VALUES
  (1, 1, 2, 1100.00, '2025-06-22 09:30:00'),
  (2, 1, 3, 1200.00, '2025-06-22 10:00:00'),
  (3, 1, 2, 1600.00, '2025-06-22 11:00:00'),
  (4, 2, 3, 600.00, '2025-06-22 10:30:00'),
  (5, 2, 4, 750.00, '2025-06-22 11:15:00'),
  (6, 2, 2, 850.00, '2025-06-22 12:00:00'),
  (7, 3, 2, 7200.00, '2025-06-22 12:30:00'),
  (8, 3, 3, 8000.00, '2025-06-22 13:00:00'),
  (9, 3, 4, 9500.00, '2025-06-22 13:30:00'),
  (10, 4, 6, 21000.00, '2025-06-23 09:30:00'),
  (11, 4, 9, 23000.00, '2025-06-23 10:00:00'),
  (12, 4, 8, 24900.00, '2025-06-23 11:00:00'),
  (13, 5, 9, 105000.00, '2025-06-23 10:30:00'),
  (14, 5, 6, 110000.00, '2025-06-23 11:00:00'),
  (15, 5, 9, 118000.00, '2025-06-23 12:00:00'),
  (16, 6, 6, 550000.00, '2025-06-23 12:30:00'),
  (17, 6, 9, 610000.00, '2025-06-23 13:00:00');

-- WINNING_BIDS
INSERT INTO winning_bids (win_id, item_id, bid_id, conversion_fee, transaction_fee, payment_status, created_at) VALUES
  (1, 1, 3, 30.00, 20.00, 'paid', '2025-06-22 17:05:00'),
  (2, 3, 9, 50.00, 40.00, 'pending', '2025-06-22 19:05:00'),
  (3, 6, 17, 10000.00, 8000.00, 'paid', '2025-06-23 19:05:00');

-- WALLET_TRANSACTIONS
INSERT INTO wallet_transactions (wallet_transaction_id, from_wallet_id, to_wallet_id, amount, transaction_type, transaction_status, created_at) VALUES
  (1, 2, 1, 1600.00, 'charges', 'completed', '2025-06-22 17:05:00'),
  (2, 4, 5, 9500.00, 'charges', 'pending', '2025-06-22 19:10:00'),
  (3, 1, 2, 100.00, 'refund', 'completed', '2025-06-22 17:10:00'),
  (4, 9, 7, 610000.00, 'charges', 'completed', '2025-06-23 19:10:00'),
  (5, 7, 9, 10000.00, 'refund', 'completed', '2025-06-23 19:15:00');

-- ACCOUNT_TRANSACTIONS
INSERT INTO account_transactions (account_transaction_id, wallet_id, bank_account_id, amount, transaction_type, transaction_status, created_at) VALUES
  (1, 1, 1, 1550.00, 'withdrawal', 'completed', '2025-06-22 18:00:00'),
  (2, 5, 4, 9400.00, 'withdrawal', 'pending', '2025-06-22 19:20:00'),
  (3, 7, 6, 602000.00, 'withdrawal', 'completed', '2025-06-23 19:20:00');

-- WALLET_TRANSACTION_BREAKDOWNS
INSERT INTO wallet_transaction_breakdowns (breakdown_id, wallet_transaction_id, amount, description, created_at) VALUES
  (1, 1, 30.00, 'Conversion fee', '2025-06-22 17:05:01'),
  (2, 1, 20.00, 'Transaction fee', '2025-06-22 17:05:02'),
  (3, 2, 50.00, 'Conversion fee', '2025-06-22 19:10:01'),
  (4, 2, 40.00, 'Transaction fee', '2025-06-22 19:10:02'),
  (5, 4, 10000.00, 'Conversion fee', '2025-06-23 19:10:01'),
  (6, 4, 8000.00, 'Transaction fee', '2025-06-23 19:10:02');

-- ACCOUNT_TRANSACTION_BREAKDOWNS
INSERT INTO account_transaction_breakdowns (breakdown_id, account_transaction_id, amount, description, created_at) VALUES
  (1, 1, 1550.00, 'Seller payout', '2025-06-22 18:00:01'),
  (2, 2, 9400.00, 'Seller payout', '2025-06-22 19:20:01'),
  (3, 3, 602000.00, 'Seller payout', '2025-06-23 19:20:01');

-- BID_AUDIT_LOGS
INSERT INTO bid_audit_logs (log_id, bid_id, item_id, user_id, action, details, timestamp) VALUES
  (1, 1, 1, 2, 'placed', 'Bid placed by Bob on Antique Vase', '2025-06-22 09:30:01'),
  (2, 2, 1, 3, 'placed', 'Bid placed by Carol on Antique Vase', '2025-06-22 10:00:01'),
  (3, 3, 1, 2, 'placed', 'Bid placed by Bob on Antique Vase', '2025-06-22 11:00:01'),
  (4, 4, 2, 3, 'placed', 'Bid placed by Carol on Rare Coin', '2025-06-22 10:30:01'),
  (5, 5, 2, 4, 'placed', 'Bid placed by Dan on Rare Coin', '2025-06-22 11:15:01'),
  (6, 6, 2, 2, 'placed', 'Bid placed by Bob on Rare Coin', '2025-06-22 12:00:01'),
  (7, 7, 3, 2, 'placed', 'Bid placed by Bob on Smartphone', '2025-06-22 12:30:01'),
  (8, 8, 3, 3, 'placed', 'Bid placed by Carol on Smartphone', '2025-06-22 13:00:01'),
  (9, 9, 3, 4, 'placed', 'Bid placed by Dan on Smartphone', '2025-06-22 13:30:01'),
  (10, 10, 4, 6, 'placed', 'Bid placed by Frank on Rolex Watch', '2025-06-23 09:30:01'),
  (11, 11, 4, 9, 'placed', 'Bid placed by Ivan on Rolex Watch', '2025-06-23 10:00:01'),
  (12, 12, 4, 8, 'placed', 'Bid placed by Heidi on Rolex Watch', '2025-06-23 11:00:01'),
  (13, 13, 5, 9, 'placed', 'Bid placed by Ivan on Vintage Car', '2025-06-23 10:30:01'),
  (14, 14, 5, 6, 'placed', 'Bid placed by Frank on Vintage Car', '2025-06-23 11:00:01'),
  (15, 15, 5, 9, 'placed', 'Bid placed by Ivan on Vintage Car', '2025-06-23 12:00:01'),
  (16, 16, 6, 6, 'placed', 'Bid placed by Frank on Picasso Painting', '2025-06-23 12:30:01'),
  (17, 17, 6, 9, 'placed', 'Bid placed by Ivan on Picasso Painting', '2025-06-23 13:00:01');
