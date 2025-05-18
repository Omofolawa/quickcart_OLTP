-- Creating database instance for data operations and transactional processing for QuickCart--
CREATE DATABASE quickcart;

USE quickcart;

-- Creating the Customer table to store customer data
CREATE TABLE Customer (
    Customer_ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    First_Name NVARCHAR(50) NOT NULL,
    Last_Name NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    Phone NVARCHAR(20),
    Address NVARCHAR(200)
);

-- Create Product table
CREATE TABLE Product (
    Product_ID INT IDENTITY(1000,1) PRIMARY KEY NOT NULL,
    Name NVARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) CHECK (Price > 0),
    Description NVARCHAR(200),
    Category NVARCHAR(50),
    SKU NVARCHAR(20) UNIQUE
);

-- Create Order table
CREATE TABLE [Order] (
    Order_ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    Customer_ID INT NOT NULL,
    Order_Date DATETIME DEFAULT CURRENT_TIMESTAMP,
    Status NVARCHAR(20) CHECK (Status IN ('Pending', 'Paid', 'Shipped', 'Delivered', 'Cancelled')),
    Total_Amount DECIMAL(10,2) CHECK (Total_Amount >= 0),
    CONSTRAINT FK_Order_Customer FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID)
);

-- Create Order_Item table
CREATE TABLE Order_Item (
    Order_Item_ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    Order_ID INT NOT NULL,
    Product_ID INT NOT NULL,
    Quantity INT CHECK (Quantity > 0),
    Unit_Price DECIMAL(10,2) CHECK (Unit_Price > 0),
    Discount DECIMAL(5,2) DEFAULT 0.00, -- Implemented for the purpose of promotional traceability --
    CONSTRAINT FK_OrderItem_Order FOREIGN KEY (Order_ID) REFERENCES [Order](Order_ID),
    CONSTRAINT FK_OrderItem_Product FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID),
    CONSTRAINT UQ_Order_Product UNIQUE (Order_ID, Product_ID) -- composite unique constraint--
);

-- Create Inventory table
CREATE TABLE Inventory (
    Inventory_ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    Product_ID INT NOT NULL,
    Quantity INT CHECK (Quantity >= 0),
    Last_Restocked DATETIME,
    Low_Stock_Threshold INT DEFAULT 5, -- Added for inventory alerts--
    CONSTRAINT FK_Inventory_Product FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID)
);

-- Create Payment table
CREATE TABLE Payment (
    Payment_ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    Order_ID INT NOT NULL,
    Amount DECIMAL(10,2) CHECK (Amount > 0),
    Payment_Method VARCHAR(30) CHECK (Payment_Method IN ('Credit Card', 'PayPal', 'Bank Transfer')),
    Status NVARCHAR(20) CHECK (Status IN ('Pending', 'Completed', 'Failed', 'Refunded')),
    Transaction_Date DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT FK_Payment_Order FOREIGN KEY (Order_ID) REFERENCES [Order](Order_ID)
);
