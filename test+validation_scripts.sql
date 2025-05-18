-- Test Data for QuickCart Database Validation--

INSERT INTO Customer (First_Name, Last_Name, Email, Phone, Address)
VALUES 
('Yumeto', 'Smith', 'yumeto.smith@test.com', '555-123-4567', '123 Main St, Anytown, UK'),
('Sarah', 'Johnson', 'sarah.j@test.com', '555-987-6543', '456 Oak Ave, Somewhere, UK'),
('Tomiwa', 'Williams', 'tomiwa.w@test.com', NULL, '789 Pine Rd, Nowhere, UK'),
('Emily', 'Brown', 'emily.b@test.com', '555-456-7890', '321 Elm St, Anywhere, UK'),
('David', 'Jones', 'david.j@test.com', '555-654-3210', '654 Maple Dr, Everywhere, UK');

INSERT INTO Product (Name, Price, Description, Category, SKU)
VALUES 
('Wireless Headphones', 99.99, 'Noise-cancelling Bluetooth headphones', 'Electronics', 'WH-1000XM4'),
('Smartphone', 799.99, 'Latest model with 128GB storage', 'Electronics', 'SP-2023PRO'),
('Coffee Maker', 49.99, '12-cup programmable coffee maker', 'Home', 'CM-12CUP'),
('Running Shoes', 89.99, 'Lightweight running shoes size 10', 'Sports', 'RS-10-M'),
('Desk Lamp', 29.99, 'LED adjustable desk lamp', 'Home', 'DL-LED-01');

INSERT INTO Inventory (Product_ID, Quantity, Last_Restocked, Low_Stock_Threshold)
VALUES 
(1000, 50, '2023-05-15', 5),
(1001, 25, '2023-06-01', 3),
(1002, 30, '2023-05-20', 10),
(1003, 15, '2023-06-10', 5),
(1004, 40, '2023-05-25', 8);

INSERT INTO [Order] (Customer_ID, Status, Total_Amount)
VALUES 
(1, 'Pending', 199.98),
(2, 'Paid', 799.99),
(3, 'Shipped', 139.98),
(4, 'Delivered', 89.99),
(5, 'Cancelled', 29.99);

INSERT INTO Order_Item (Order_ID, Product_ID, Quantity, Unit_Price, Discount)
VALUES 
(1, 1000, 2, 99.99, 0.00),  -- Order 1: 2 headphones
(2, 1001, 1, 799.99, 0.00),  -- Order 2: 1 smartphone
(3, 1000, 1, 99.99, 0.00),   -- Order 3: 1 headphone
(3, 1004, 1, 29.99, 10.00),  -- Order 3: 1 desk lamp with $10 discount
(4, 1003, 1, 89.99, 0.00),   -- Order 4: 1 running shoes
(5, 1004, 1, 29.99, 0.00);   -- Order 5: 1 desk lamp (cancelled)

INSERT INTO Payment (Order_ID, Amount, Payment_Method, Status)
VALUES 
(2, 799.99, 'Credit Card', 'Completed'),
(3, 129.98, 'PayPal', 'Completed'),  -- $139.98 total with $10 discount
(4, 89.99, 'Bank Transfer', 'Completed'),
(5, 29.99, 'Credit Card', 'Refunded');  -- Cancelled order

-- Defined-Validation Tests

-- 1) Test Foreign Key Constraints

-- Should fail (invalid Customer_ID)
INSERT INTO [Order] (Customer_ID, Status, Total_Amount) 
VALUES (99, 'Pending', 100.00);

-- Should fail (invalid Product_ID)
INSERT INTO Order_Item (Order_ID, Product_ID, Quantity, Unit_Price) 
VALUES (1, 9999, 1, 99.99);

-- 2) Test Unique Constraints
-- Should fail (duplicate email)
INSERT INTO Customer (First_Name, Last_Name, Email, Phone) 
VALUES ('Test', 'User', 'yumeto.smith@test.com', '555-000-0000');

-- Should fail (duplicate SKU)
INSERT INTO Product (Name, Price, SKU) 
VALUES ('Test Product', 10.00, 'WH-1000XM4');

-- 3) Test Check Constraints
-- Should fail (negative price)
INSERT INTO Product (Name, Price) VALUES ('Invalid Product', -10.00);

-- Should fail (invalid status)
INSERT INTO [Order] (Customer_ID, Status, Total_Amount) 
VALUES (1, 'InvalidStatus', 100.00);

-- 4) Test Composite Unique Constraint
-- Should fail (duplicate product in same order)
INSERT INTO Order_Item (Order_ID, Product_ID, Quantity, Unit_Price) 
VALUES (1, 1000, 1, 99.99);

-- 5) Test Default Values
-- Should succeed with default discount (0.00)
INSERT INTO Order_Item (Order_ID, Product_ID, Quantity, Unit_Price) 
VALUES (1, 1002, 1, 49.99);

-- Should succeed with current timestamp
INSERT INTO [Order] (Customer_ID, Status, Total_Amount) 
VALUES (1, 'Pending', 49.99);