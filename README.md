# JDBC Auction System

A Java-based auction management system using JDBC for database connectivity.

## Features

- User management with KYC verification
- Auction creation and management
- Bidding system with real-time tracking
- Wallet and transaction management
- Database-driven auction queries

## Database Schema

The project uses MySQL with the following main tables:
- `users` - User information and KYC status
- `auctions` - Auction details and scheduling
- `items` - Items for auction
- `bids` - Bidding history
- `wallets` - User wallet management
- `winning_bids` - Auction winners

## Setup

1. **Database Setup**
   - Create a MySQL database
   - Run the `schema.sql` file to create tables and sample data

2. **Compilation**
   ```bash
   javac -cp "lib/mysql-connector-j-9.4.0.jar:." -d . src/**/*.java src/*.java
   ```

3. **Running the Application**
   ```bash
   java -cp "lib/mysql-connector-j-9.4.0.jar:." Main
   ```

4. **Database Configuration**
   - The application will prompt for database connection details:
     - Host (e.g., localhost or 127.0.0.1)
     - Port (default: 3306)
     - Database name
     - Username
     - Password

## Project Structure

```
├── src/
│   ├── Main.java              # Main application entry point
│   ├── DAO/                   # Data Access Objects
│   │   ├── BidsDAO.java
│   │   ├── ItemsDAO.java
│   │   ├── UserDAO.java
│   │   └── WalletsDAO.java
│   ├── db/
│   │   └── DBConnector.java   # Database connection management
│   └── entity/                # Entity classes
│       ├── Bids.java
│       ├── Items.java
│       ├── User.java
│       └── Wallets.java
├── lib/
│   └── mysql-connector-j-9.4.0.jar  # MySQL JDBC driver
└── schema.sql                 # Database schema and sample data
```

## Queries Implemented

1. **Current Highest Bid per Item** - Retrieves the highest bid for each auction item
2. **Active Auctions Ending Soon** - Lists auctions ending within 1 hour
3. **Winning Bidders** - Shows winners for completed auctions
4. **Bidding History** - Displays bid history for specific items
5. **User Bid Statistics** - Computes total bids by user in a time period

## Dependencies

- Java 8 or higher
- MySQL 8.0+
- MySQL Connector/J 9.4.0
