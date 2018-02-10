DROP DATABASE IF EXISTS lgc;                            /* Delete and existence of database prior to creation */
DROP USER IF EXISTS 'user1'@'localhost';                /* Remove any existence of current users */
DROP USER IF EXISTS 'user2'@'localhost';
DROP USER IF EXISTS 'user3'@'localhost';

CREATE DATABASE IF NOT EXISTS lgc;                      /* Create Database */
USE lgc;

/* ----------Implementing DDL----------- */

/* Create table to store customer details */
CREATE TABLE IF NOT EXISTS customers (
    CustEmail varchar(200) NOT NULL,
    CustFirstName varchar(100) NOT NULL,
    CustLastName varchar(100) NOT NULL,
    DOB DATE NOT NULL,
    PRIMARY KEY(CustEmail)
);

/* create table to store item details */
CREATE TABLE IF NOT EXISTS items (
    ItemID INT AUTO_INCREMENT,
    LatinName varchar(75) NOT NULL,
    PopularName varchar(75) NOT NULL,
    FullDesc varchar(200),
    Category varchar(100) NOT NULL,
    SoI varchar(20),
    Attributes varchar(100),
    Price FLOAT NOT NULL,
    PRIMARY KEY(ItemID, LatinName)
);

/* Create table to store staff details */
CREATE TABLE IF NOT EXISTS staff (
    StaffEmail varchar(200) NOT NULL,
    StaffFirstName varchar(100) NOT NULL,
    StaffLastName varchar(100) NOT NULL,
    HouseNo INT NOT NULL,
    StreetName varchar(75),
    City varchar(50),
    Postcode varchar(8) NOT NULL,
    PRIMARY KEY(StaffEmail)
);

/* Create table to store supplier details */
CREATE TABLE IF NOT EXISTS suppliers (
    SupEmail varchar(200) NOT NULL,
    SupName varchar(100) NOT NULL,
    HouseNo INT NOT NULL,
    StreetName varchar(75),
    City varchar(50),
    Postcode varchar(8),
    PRIMARY KEY(SupEmail)
);

/* Create table to store customer orders */
CREATE TABLE IF NOT EXISTS customerorders (
    OrderID INT NOT NULL,
    CustEmail varchar(200) NOT NULL,
    ItemID INT NOT NULL,
    Quantity INT DEFAULT 1,
    OrderDate DATE NOT NULL,
    OrderStatus varchar(15) DEFAULT 'Pending',
    OrderTotal FLOAT NOT NULL,
    DespatchDate DATE,
    PayReceived BOOLEAN DEFAULT FALSE,
    Discount FLOAT DEFAULT 0.0,
    PRIMARY KEY(OrderID, ItemID),                            /* Set composite key */
    FOREIGN KEY (CustEmail) REFERENCES customers (CustEmail) 
    ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (ItemID) REFERENCES items (ItemID) 
    ON UPDATE CASCADE ON DELETE CASCADE
);

/* Create table for customer order invoices */
CREATE TABLE IF NOT EXISTS invoices (
    InvoiceID INT AUTO_INCREMENT,
    OrderID INT NOT NULL,
    CustEmail varchar(200) NOT NULL,
    InvoiceSent DATE,
    PRIMARY KEY(InvoiceID),
    FOREIGN KEY (CustEmail) REFERENCES customers (CustEmail) 
    ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (OrderID) REFERENCES customerorders (OrderID) /* Apply foreign key from customer orders table */
    ON UPDATE CASCADE ON DELETE CASCADE                       /* Delete invoice if order is deleted */
);

/* Create table or item purchase orders */
CREATE TABLE IF NOT EXISTS purchaseorders (
    pOrderID INT AUTO_INCREMENT,
    ItemID INT,
    pOrderStatus varchar(20) DEFAULT 'Pending',
    Quantity INT NOT NULL,
    PayDate DATE,
    pOrderDate DATE NOT NULL,
    PRIMARY KEY(pOrderID),
    FOREIGN KEY (ItemID) REFERENCES items (ItemID)  
    ON UPDATE CASCADE ON DELETE CASCADE
);

/* Create table to store customer addresses */
CREATE TABLE IF NOT EXISTS addresses (
    HouseNo varchar(50) NOT NULL,
    StreetName varchar(75),
    City varchar(50) NOT NULL,
    Postcode varchar(8) NOT NULL,
    CustEmail varchar(200) NOT NULL, 
    PRIMARY KEY (Postcode),
    FOREIGN KEY (CustEmail) REFERENCES customers (CustEmail) 
    ON UPDATE CASCADE ON DELETE CASCADE
);

/* 1iv) */
ALTER TABLE staff CHANGE HouseNo HouseName varchar(20);             -- Change name of house number column 
ALTER TABLE addresses CHANGE HouseNo HouseName varchar(20);     
ALTER TABLE addresses ADD addressType varchar(20) NOT NULL;         -- Add column regarding what address type 
ALTER TABLE addresses DROP PRIMARY KEY;                             -- Remove current primary key value
ALTER TABLE addresses ADD PRIMARY KEY(HouseName,Postcode,CustEmail, addressType);   -- Add new primary key
ALTER TABLE purchaseorders ADD SupplierEmail varchar(200);          -- Add supplier email column to purchase orders 
ALTER TABLE customerorders MODIFY COLUMN OrderTotal DECIMAL(5,2);   -- Display values after decimal point 
ALTER TABLE items MODIFY COLUMN Price DECIMAL(5,2);                 -- Display values after decimal point 
ALTER TABLE items DROP COLUMN Attributes;                           -- Drop attributes column
ALTER TABLE purchaseorders ADD FOREIGN KEY (supplierEmail) REFERENCES suppliers (SupEmail)
ON UPDATE CASCADE ON DELETE CASCADE;                                -- Apply foreign key to supplier email 

/* ------------Implementing DML------------- */

/* 2i) */
INSERT INTO customers VALUES                                                                            -- Add values into customers table 
('shaunevans@gmail.com', 'Shaun', 'Evans', '1982-11-15'), 
('terryandrews@gmail.com', 'Terry', 'Andrews', '1960-12-22'),
('emilysimpson@gmail.com', 'Emily', 'Simpson', '1992-02-04'),
('charliepeak@gmail.com', 'Charlie', 'Peak', '1988-06-01'),
('chrisstevenson@gmail.com', 'Chris', 'Stevenson', '1993-09-20'),
('gerrismith@gmail.com', 'Gerri', 'Smith', '1982-02-10'),
('samantharoyal@gmail.com', 'Samantha', 'Royal', '1955-08-21'),
('kevinbaker@gmail.com', 'Kevin', 'Baker', '1967-03-14'),
('juliesmith@gmail.com', 'Julie', 'Smith', '1968-12-20'),
('chloewallace@gmail.com', 'Chloe', 'Wallace', '1992-04-05');

INSERT INTO staff VALUES                                                                                -- Add values to staff table 
('louiebell@lgcstaff.com', 'Louie', 'Bell', '122', 'Bell Cresent', 'Lincoln', 'LN5 2RF'),
('grahamsmall@lgcstaff.com', 'Graham', 'Small', '3', 'Turf Road', 'Lincoln', 'LN4 1TT'),
('elliewhite@lgcstaff.com', 'Ellie', 'White', '19', 'Green Lane', 'Lincoln', 'LN3 2LF'),
('ethanstokes@lgcstaff.com', 'Ethan', 'Stokes', 'River View', 'Farm Lane', 'Lincoln', 'LN3 5QN'),
('vincentdrake@lgcstaff.com', 'Vincent', 'Drake', '41', 'Reach Close', 'Lincoln', 'LN4 7BN'),
('paulstack@lgcstaff.com', 'Paul', 'Stack', 'Waterfront', 'Brayford Road', 'Lincoln', 'LN5 4BT'),
('louisasmall@lgcstaff.com', 'Louisa', 'Small', '99', 'Church Road', 'Lincoln', 'LN2 4RT'),
('evanmay@lgcstaff.com', 'Evan', 'May', 'River Bay', 'Brayford Road', 'Lincoln', 'LN5 4BT');

INSERT INTO items (LatinName, PopularName, FullDesc, Category, SoI, Price) VALUES                       -- Add values into items table 
('Alnus Glutinosa', 'Common Alder', 'A slightly tall tree', 'Tree', 'Summer', 20.00),
('Cornus Florida', 'Florida Dogwood', 'A collection of ugly leaves', 'Climber', 'Winter', 5.00),
('Laburnum', 'Golden Chain', 'Actually quite pretty', 'Climber', 'Spring', 12.00),
('Pueraria Montana', 'Kudzu', 'Funny looking red plant', 'Shrub', 'Summer', 4.00),
('Lavandula Angustifolia', 'Lavendar', 'Pretty purple thing', 'Shrub', NULL, 2.25),
('Betula Pendula', 'Silver birch', 'Long thin tree', 'Tree', 'Autumn', 13.00),
('Ambrosia Trifida', 'Buffalo Weed', 'Look a bit like french fries', 'Shrub', NULL, 2.00),
('Helleborus', 'Hellebore', 'Pretty pink thing', 'Shrub', 'Summer', 6.50); 

INSERT INTO suppliers VALUES                                                                            -- Add suppliers to table 
('localplants@gmail.com', 'Steve\'s Plants', '3', 'Greenwich Lane', 'Nottingham', 'NG23 2PT'),
('lincolntrees@gmail.com', 'Lincoln Trees', '66', 'Plant Lane', 'Lincoln', 'LN1 2PP'),
('greenandgo@gmail.com', 'Green and Go', '44', 'Park Street', 'Lincoln', 'LN3 6RE'),
('shrubbers@gmail.com', 'Shrubbers', '11', 'Green Park', 'Lincoln', 'LN5 6LP');

/* Add information about customer orders */
INSERT INTO customerorders (OrderID, CustEmail, ItemID, Quantity, OrderDate, OrderStatus, OrderTotal, PayReceived) VALUES
(111, 'shaunevans@gmail.com', 3, 2, '2017-12-19', 'Pending', 10.00, FALSE),
(111, 'shaunevans@gmail.com', 1, 1, '2017-12-19', 'Pending', 20.00, FALSE),
(112, 'gerrismith@gmail.com', 4, 4, '2017-12-16', 'Sent', 16.00, FALSE),
(113, 'chrisstevenson@gmail.com', 6, 2, '2017-12-20', 'Pending', 26.00, FALSE),
(114, 'samantharoyal@gmail.com', 3, 1, '2017-12-16', 'Sent', 12.00, FALSE),
(114, 'samantharoyal@gmail.com', 2, 3, '2017-12-16', 'Sent', 15.00, FALSE),
(115, 'terryandrews@gmail.com', 5, 2, '2017-12-30', 'Pending', 4.50, FALSE),
(115, 'terryandrews@gmail.com', 1, 3, '2017-12-30', 'Pending', 60.00, FALSE),
(115, 'terryandrews@gmail.com', 3, 5, '2017-12-30', 'Pending', 60.00, FALSE),
(116, 'chrisstevenson@gmail.com', 2, 2, '2018-01-01', 'Pending', 10.00, FALSE);

INSERT INTO invoices (OrderID, CustEmail, InvoiceSent) VALUES               -- Don't include invoice ID as it is auto increment 
(111, 'shaunevans@gmail.com', '2017-12-20'),
(112, 'gerrismith@gmail.com', '2017-12-17'),
(113, 'chrisstevenson@gmail.com', '2017-12-21'),
(114, 'samantharoyal@gmail.com', '2017-12-18'),
(115, 'terryandrews@gmail.com', NULL),
(116, 'chrisstevenson@gmail.com', NULL);

INSERT INTO addresses VALUES                                                -- Add customer addresses to address table 
('4', 'Tree Cresent', 'Norwich', 'NR3 5LP', 'shaunevans@gmail.com', 'Delivery'),
('1', 'Hall Road', 'Norwich', 'NR29 4PR', 'shaunevans@gmail.com', 'Billing'),
('123', 'Sunflower Lane', 'London', 'NW2 2LL', 'terryandrews@gmail.com', 'Both'),
('7', 'Bridge Park', 'Peterborough', 'PE1 3LI', 'emilysimpson@gmail.com', 'Delivery'),
('11', 'Bluebell Gate', 'Peterborough', 'PE1 2RA', 'emilysimpson@gmail.com', 'Billing'),
('Brayford View', 'Brayford Wharf', 'Lincoln', 'LN5 6RT', 'charliepeak@gmail.com', 'Delivery'),
('28', 'Station Road', 'Lincoln', 'LN5 3FE', 'charliepeak@gmail.com', 'Billing'),
('2', 'West Lane', 'London', 'W3 4YT', 'chrisstevenson@gmail.com', 'Both'),
('15', 'Bell Lane', 'Norwich', 'NR4 2CV', 'gerrismith@gmail.com', 'Delivery'),
('24', 'Willow Close', 'Norwich', 'NR3 2LP', 'gerrismith@gmail.com', 'Billing'),
('75', 'Back Lane', 'Norwich', 'NR29 2DW', 'juliesmith@gmail.com', 'Both'),
('Rovers', 'New Road', 'London', 'E23 4DV', 'chloewallace@gmail.com', 'Both'),
('Tin Pot', 'Green Street', 'Nottingham', 'NG4 1SB', 'kevinbaker@gmail.com', 'Both'),
('Sunflower Cottage', 'Meadow Street', 'Norwich', 'NR27 3QE', 'samantharoyal@gmail.com', 'Both');

/* Add information about item purchase orders */
INSERT INTO purchaseorders (ItemID, pOrderStatus, Quantity, PayDate, pOrderDate, SupplierEmail) VALUES
(1, 'Paid', 20, '2018-01-05', '2017-12-05', 'lincolntrees@gmail.com'),
(6, 'Pending', 15, '2018-01-29', '2017-12-29', 'lincolntrees@gmail.com'),
(3, 'Received', 40, '2018-01-15', '2017-12-15', 'localplants@gmail.com'),
(4, 'Sent', 50, '2018-02-01', '2018-01-01', 'greenandgo@gmail.com'),
(8, 'Paid', 35, '2018-01-08', '2017-12-08', 'shrubbers@gmail.com'),
(1, 'Pending', 20, '2018-02-08', '2018-01-08', 'lincolntrees@gmail.com');

/* Set variables for order dates */
SET @startdeliveries = '2017-12-17';
SET @enddeliveries = '2017-12-24';

/* Set variables for order status' */
SET @sentstatus = 'Sent';
SET @receivedstatus = 'Received';
SET @pendingstatus = 'Pending';
SET @paidstatus = 'Paid';

-- Change customer email and last name
UPDATE customers SET CustEmail = 'emilycarter@gmail.com', CustLastName='Carter' WHERE CustEmail='emilysimpson@gmail.com';
UPDATE purchaseorders SET Quantity = 35 WHERE ItemID=6;                                             -- Increase quantity on purchase order

/* Update rows to change order stauts after specified date */
UPDATE customerorders SET OrderStatus = @sentstatus, DespatchDate = @enddeliveries WHERE OrderDate BETWEEN @startdeliveries AND @enddeliveries;
UPDATE customerorders SET OrderStatus = @receivedstatus, DespatchDate = @startdeliveries WHERE OrderDate < @startdeliveries;
UPDATE customerorders SET OrderStatus = @paidstatus, PayReceived = TRUE WHERE CustEmail='samantharoyal@gmail.com';
DELETE FROM purchaseorders WHERE ItemID=1 AND pOrderStatus=@paidstatus;                             -- Delete specific purchase order 

-- Variables of order discount
SET @orderprice = 0;
SET @dvalue = 10;
SELECT @orderprice := OrderTotal FROM customerorders WHERE CustEmail='gerrismith@gmail.com';        -- Select price paid for order 

/* Apply discount and add value to discount column */
UPDATE customerorders SET OrderTotal = @orderprice - (@orderprice / @dvalue), Discount = @dvalue WHERE CustEmail = 'gerrismith@gmail.com'; 
DELETE FROM staff WHERE StaffEmail = 'ethanstokes@lgcstaff.com';                                    -- Delete staff member 


/* 2ii) */
SELECT customerorders.CustEmail AS Email, customerorders.ItemID, customerorders.OrderTotal, invoices.InvoiceSent FROM customerorders 
RIGHT JOIN invoices 
ON customerorders.OrderID = invoices.OrderID ORDER BY customerorders.OrderID;   -- Display details about ccustomers that have invoices 

/* Display details regarding customers order and where they're being delivered */
SELECT CONCAT(customers.CustFirstName, " ", customers.CustLastName) AS Name, addresses.HouseName, addresses.StreetName, addresses.Postcode, customerorders.ItemID, customerorders.Quantity, customerorders.OrderStatus FROM customers
INNER JOIN addresses
ON customers.CustEmail = addresses.CustEmail AND (addressType="Delivery" OR addressType="Both")     -- Retrieve delivery address
INNER JOIN customerorders
ON customerorders.CustEmail = customers.CustEmail;

/* Display all cusomters and their relevant addresses */
SELECT CONCAT(customers.CustFirstName, " ", customers.CustLastName) AS Name, CONCAT(addresses.StreetName, ", ", addresses.City, ", ", addresses.Postcode) AS Address, addresses.addressType 
FROM customers INNER JOIN addresses 
ON addresses.CustEmail = customers.CustEmail;

SELECT items.PopularName, purchaseorders.pOrderStatus, purchaseorders.Quantity, purchaseorders.PayDate FROM items
LEFT JOIN purchaseorders
ON items.ItemID = purchaseorders.ItemID;                                -- Display details of items that have pruchase orders 

/* 2iii) */
/* Show customers that haven't paid since invoice received */
SELECT customerorders.OrderID, customerorders.CustEmail FROM customerorders WHERE OrderStatus IN ('Sent', 'Received')
UNION
SELECT invoices.OrderID, invoices.CustEmail FROM invoices WHERE InvoiceSent < '2017-12-21'; 

/* 2iv) */             
CREATE TABLE copy_of_customers LIKE customers; 
INSERT copy_of_customers SELECT * FROM customers;                       -- Copy of customers table 
CREATE TABLE copy_of_staff LIKE staff; 
INSERT copy_of_staff SELECT * FROM staff;                               -- Copy of copy of staff table 
CREATE TABLE copy_of_items LIKE items; 
INSERT copy_of_items SELECT * FROM items;                               -- Copy of items table 
CREATE TABLE copy_of_suppliers LIKE suppliers; 
INSERT copy_of_suppliers SELECT * FROM suppliers;                       -- Copy of suppliers table 
CREATE TABLE copy_of_addresses LIKE addresses; 
INSERT copy_of_addresses SELECT * FROM addresses;                       -- Copy of addresses table 
CREATE TABLE copy_of_customerorders LIKE customerorders; 
INSERT copy_of_customerorders SELECT * FROM customerorders;             -- Copy of orders table 
CREATE TABLE copy_of_invoices LIKE invoices; 
INSERT copy_of_invoices SELECT * FROM invoices;                         -- Copy of invoices table 
CREATE TABLE copy_of_purchaseorders LIKE purchaseorders; 
INSERT copy_of_purchaseorders SELECT * FROM purchaseorders;             -- Copy of purchase orders table 

/* 2v) */
CREATE USER 'user1'@'localhost' IDENTIFIED BY 'P4s$w0rd';               -- Create new user with password = P4s$w0rd 
GRANT SELECT ON lgc.* TO 'user1'@'localhost';                           -- Grant read privileges on user 

CREATE USER 'user2'@'localhost' IDENTIFIED BY 'P4s$w0rd';
GRANT INSERT, SELECT, UPDATE ON lgc.staff TO 'user2'@'localhost';       -- Allow user2 to add new staff 

CREATE USER 'user3'@'localhost' IDENTIFIED BY 'P4s$w0rd';               -- Allow user to update all tables 
GRANT UPDATE ON lgc.* TO 'user3'@'localhost';

/* 2vi) */

DELIMITER //                                                            -- Declare a new delimiter for procedure 
DROP PROCEDURE IF EXISTS nullInvoice//                                  -- Remove any existence of procedure
   
CREATE PROCEDURE nullInvoice(IN InvoiceDate DATE)                       -- create new procedure to replace null values
BEGIN                                                                   -- Start procedure

DECLARE invoicesize INT DEFAULT 0;                                      -- Initialise variable value
SELECT COUNT(*) INTO invoicesize FROM invoices;                         -- Variable to store size of table
SET @x = 1;

WHILE @x <= invoicesize DO                                                                      -- Loop through table values
UPDATE invoices SET InvoiceSent = InvoiceDate WHERE InvoiceSent IS NULL AND InvoiceID = @x;     -- Set value to replace null
SET @x = @x + 1;                                                                                -- increment counter variable
END WHILE;

END//                                                                   -- end of procedure
DELIMITER ;                                                             -- Reset delimiter to ; 

/* Procedure to set season of interest on item */
DELIMITER $$                                                            -- Create new delimiter
DROP PROCEDURE IF EXISTS nullItems$$

CREATE PROCEDURE nullItems()                                            -- Procedure to set values in items that are null
BEGIN

DECLARE itemssize INT DEFAULT 0;
SELECT COUNT(*) INTO itemssize FROM items;                              -- Variable to store size of table
SET @y = 1;

WHILE @y <= itemssize DO                                                        -- Loop through table values
UPDATE items SET SoI = 'All Seasons' WHERE SoI IS NULL AND ItemID = @y;         -- Statement to replace null value
SET @y = @y + 1;
END WHILE;

END$$
DELIMITER ;                                                             -- Reset delimiter to ; 

/* Procedure to send customer deliveries */
DELIMITER //
DROP PROCEDURE IF EXISTS notDelivered//

CREATE PROCEDURE notDelivered(IN deliverDate DATE)                                  -- Take a date as an input argument
BEGIN

DECLARE ordersize INT DEFAULT 0;
SELECT COUNT(*) INTO ordersize FROM customerorders;                                 -- Variable to store size of table
SET @Z = 111;

WHILE @Z <= ordersize + 110 DO                                                       -- Loop through table values
UPDATE customerorders SET DespatchDate = deliverDate, OrderStatus = 'Sent' WHERE DespatchDate IS NULL AND OrderID = @z;
SET @Z = @Z + 1;
END WHILE;

END//
DELIMITER ;                                                                         -- Set delimeter back to ;

/* Call stored procedures */
CALL nullInvoice('2018-01-14');
CALL nullItems();
CALL notDelivered('2018-01-16');
    