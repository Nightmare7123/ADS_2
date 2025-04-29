-- Anupam Kamble (22510041)

CREATE DATABASE HeadquarterDB;
CREATE DATABASE SalesDB;

USE HeadquarterDB;
-- headquarter Databse :
CREATE TABLE Customer (
    Customer_id INT PRIMARY KEY,
    Customer_name VARCHAR(255),
    City_id INT,
    First_order_date DATE
);

CREATE TABLE Walk_in_customers (
    Customer_id INT PRIMARY KEY,
    tourism_guide VARCHAR(255),
    Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Customer_id) REFERENCES Customer(Customer_id)
);

CREATE TABLE Mail_order_customers (
    Customer_id INT PRIMARY KEY,
    post_address VARCHAR(255),
    Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Customer_id) REFERENCES Customer(Customer_id)
);



USE HeadquarterDB;
-- Adding information

INSERT INTO Customer (Customer_id, Customer_name, City_id, First_order_date) VALUES
(1, 'Abhay Jadhav', 101, '2023-01-15'),
(2, 'Aditya Kathe', 102, '2023-02-20'),
(3, 'Omkar patange', 103, '2023-03-10');

INSERT INTO Customer (Customer_id, Customer_name, City_id, First_order_date) VALUES
(4, 'Michael Brown', 104, '2023-04-05'),
(5, 'Emma Davis', 105, '2023-05-15'),	
(6, 'Liam Wilson', 106, '2023-06-25');

INSERT INTO Walk_in_customers (Customer_id, tourism_guide, Time) VALUES
(1, 'Guide A', NOW()),
(3, 'Guide B', NOW());

INSERT INTO Mail_order_customers (Customer_id, post_address, Time) VALUES
(2, '123 Satara, NY', NOW()),
(3, '456 sangli, CA', NOW());





USE SalesDB;

-- Sales databases
CREATE TABLE Headquarters (
    City_id INT PRIMARY KEY,
    City_name VARCHAR(255),
    Headquarter_addr VARCHAR(255),
    State VARCHAR(100),
    Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Stores (
    Store_id INT PRIMARY KEY,
    City_id INT,
    Phone VARCHAR(20),
    Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (City_id) REFERENCES Headquarters(City_id)
);

CREATE TABLE Items (
    Item_id INT PRIMARY KEY,
    Description VARCHAR(255),
    Size VARCHAR(50),
    Weight DECIMAL(10,2),
    Unit_price DECIMAL(10,2),
    Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Stored_items (
    Store_id INT,
    Item_id INT,
    Quantity_held INT,
    Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (Store_id, Item_id),
    FOREIGN KEY (Store_id) REFERENCES Stores(Store_id),
    FOREIGN KEY (Item_id) REFERENCES Items(Item_id)
);

CREATE TABLE Orders (
    Order_no INT PRIMARY KEY,
    Order_date DATE,
    Customer_id INT
);

CREATE TABLE Ordered_item (
    Order_no INT,
    Item_id INT,
    Quantity_ordered INT,
    Ordered_price DECIMAL(10,2),
    Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (Order_no, Item_id),
    FOREIGN KEY (Order_no) REFERENCES Orders(Order_no),
    FOREIGN KEY (Item_id) REFERENCES Items(Item_id)
);

-- adding the values
USE SalesDB;
INSERT INTO Headquarters (City_id, City_name, Headquarter_addr, State, Time) VALUES
(101, 'Sangli', 'HQ NY Address', 'NY', NOW()),
(102, 'Satara', 'HQ LA Address', 'CA', NOW()),
(103, 'Shirdi', 'HQ CH Address', 'IL', NOW());



INSERT INTO Stores (Store_id, City_id, Phone, Time) VALUES
(1, 101, '8010-4456-10', NOW()),
(2, 102, '721-825-7160', NOW()),
(3, 103, '555-666-7777', NOW());
INSERT INTO Stores (Store_id, City_id, Phone, Time) VALUES
(4, 101, '111-222-3333', NOW()),
(5, 102, '444-555-6666', NOW());


INSERT INTO Items (Item_id, Description, Size, Weight, Unit_price, Time) VALUES
(101, 'Laptop', '15 inch', 2.5, 1200.00, NOW()),
(102, 'Smartphone', '6 inch', 0.5, 800.00, NOW()),
(103, 'Tablet', '10 inch', 1.0, 600.00, NOW());
INSERT INTO Items (Item_id, Description, Size, Weight, Unit_price, Time) VALUES
(104, 'Gaming Laptop', '17 inch', 3.0, 2000.00, NOW()),
(105, 'Smart TV', '55 inch', 15.0, 1500.00, NOW());

INSERT INTO Stored_items (Store_id, Item_id, Quantity_held, Time) VALUES
(1, 101, 3, NOW()),
(2, 102, 7, NOW()),
(3, 103, 10, NOW());
INSERT INTO Stored_items (Store_id, Item_id, Quantity_held, Time) VALUES
(3, 104, 5, NOW()),
(1, 105, 8, NOW()),
(1, 102, 12, NOW()),
(2, 103, 7, NOW()),
(3, 101, 10, NOW());
INSERT INTO Stored_items (Store_id, Item_id, Quantity_held, Time) VALUES
(4, 104, 5, NOW()),
(4, 105, 8, NOW()),
(4, 102, 12, NOW()),
(1, 103, 7, NOW()),
(2, 101, 10, NOW());


INSERT INTO Orders (Order_no, Order_date, Customer_id) VALUES
(1001, '2024-01-10', 1),
(1002, '2024-01-12', 2),
(1003, '2024-01-15', 3);

INSERT INTO Orders (Order_no, Order_date, Customer_id) VALUES
(1004, '2024-02-05', 1),
(1005, '2024-02-10', 1),
(1006, '2024-02-15', 2),
(1007, '2024-02-20', 3),
(1008, '2024-02-05', 4),
(1009, '2024-02-10', 3),
(1010, '2024-02-15', 5),
(1011, '2024-02-20', 2),
(1012, '2024-02-25', 2);

INSERT INTO Ordered_item (Order_no, Item_id, Quantity_ordered, Ordered_price, Time) VALUES
(1001, 101, 1, 1200.00, NOW()),
(1002, 102, 2, 1600.00, NOW()),
(1003, 103, 1, 600.00, NOW());
INSERT INTO Ordered_item (Order_no, Item_id, Quantity_ordered, Ordered_price, Time) VALUES
(1004, 104, 1, 2000.00, NOW()),
(1005, 105, 2, 3000.00, NOW()),
(1006, 103, 3, 750.00, NOW()),
(1007, 101, 1, 500.00, NOW()),
(1008, 102, 3, 750.00, NOW()),
(1009, 104, 1, 500.00, NOW()),
(1010, 101, 3, 750.00, NOW()),
(1011, 105, 1, 500.00, NOW()),
(1012, 104, 2, 600.00, NOW());






-- USE HeadquarterDB;
-- SELECT * FROM Customer;
-- SELECT * FROM Walk_in_customers;
-- SELECT * FROM Mail_order_customers;



USE SalesDB;
SELECT * FROM Headquarters;
SELECT * FROM Stores;
SELECT * FROM Items;
SELECT * FROM Stored_items;
SELECT * FROM Orders;
SELECT * FROM Ordered_item;


-- creating the warehouse 

CREATE DATABASE DataWarehouse;
USE DataWarehouse;

CREATE TABLE fact_orders (
    Order_no INT,
    Customer_id INT,
    Store_id INT,
    Item_id INT,
    Quantity_ordered INT,
    Ordered_price DECIMAL(10,2),
    Time_id DATE,
    PRIMARY KEY (Order_no, Item_id)
);

CREATE TABLE dim_customers (
    Customer_id INT PRIMARY KEY,
    Customer_name VARCHAR(255),
    City_id INT,
    First_order_date DATE
);

CREATE TABLE dim_stores (
    Store_id INT PRIMARY KEY,
    City_id INT,
    Phone VARCHAR(20)
);

CREATE TABLE dim_items (
    Item_id INT PRIMARY KEY,
    Description VARCHAR(255),
    Size VARCHAR(50),
    Weight DECIMAL(10,2),
    Unit_price DECIMAL(10,2)
);

CREATE TABLE dim_time (
    Time_id DATE PRIMARY KEY
);


-- loading data into the warehouse 

INSERT INTO dim_customers (Customer_id, Customer_name, City_id, First_order_date)
SELECT Customer_id, Customer_name, City_id, First_order_date FROM HeadquarterDB.Customer;

INSERT INTO dim_stores (Store_id, City_id, Phone)
SELECT Store_id, City_id, Phone FROM SalesDB.Stores;

INSERT INTO dim_items (Item_id, Description, Size, Weight, Unit_price)
SELECT Item_id, Description, Size, Weight, Unit_price FROM SalesDB.Items;

INSERT INTO dim_time (Time_id)
SELECT DISTINCT Order_date FROM SalesDB.Orders;

INSERT INTO fact_orders (Order_no, Customer_id, Store_id, Item_id, Quantity_ordered, Ordered_price, Time_id)
SELECT o.Order_no, o.Customer_id, si.Store_id, oi.Item_id, oi.Quantity_ordered, oi.Ordered_price, o.Order_date
FROM SalesDB.Orders o
JOIN SalesDB.Ordered_item oi ON o.Order_no = oi.Order_no
JOIN SalesDB.Stored_items si ON oi.Item_id = si.Item_id;
use HeadquarterDB ;


-- Que 1
SELECT s.Store_id, h.City_name, h.State, s.Phone, i.Description, i.Size, i.Weight, i.Unit_price
FROM SalesDB.Stored_items si
JOIN SalesDB.Stores s ON si.Store_id = s.Store_id
JOIN SalesDB.Headquarters h ON s.City_id = h.City_id
JOIN SalesDB.Items i ON si.Item_id = i.Item_id
WHERE si.Item_id = 102;

-- que2 
SELECT o.Order_no, c.Customer_name, o.Order_date
FROM SalesDB.Orders o
JOIN SalesDB.Ordered_item oi ON o.Order_no = oi.Order_no
JOIN SalesDB.Stored_items si ON oi.Item_id = si.Item_id
JOIN HeadquarterDB.Customer c ON o.Customer_id = c.Customer_id
WHERE si.Store_id = 2;

-- que3
SELECT DISTINCT s.Store_id, h.City_name, s.Phone
FROM SalesDB.Ordered_item oi
JOIN SalesDB.Orders o ON oi.Order_no = o.Order_no
JOIN SalesDB.Stored_items si ON oi.Item_id = si.Item_id
JOIN SalesDB.Stores s ON si.Store_id = s.Store_id
JOIN SalesDB.Headquarters h ON s.City_id = h.City_id
WHERE o.Customer_id = 1;

-- que4
SELECT h.Headquarter_addr, h.City_name, h.State
FROM SalesDB.Stored_items si
JOIN SalesDB.Stores s ON si.Store_id = s.Store_id
JOIN SalesDB.Headquarters h ON s.City_id = h.City_id
WHERE si.Item_id = 102 AND si.Quantity_held > 2;


-- que5
SELECT o.Order_no, i.Description, s.Store_id, h.City_name
FROM SalesDB.Ordered_item oi
JOIN SalesDB.Orders o ON oi.Order_no = o.Order_no
JOIN SalesDB.Items i ON oi.Item_id = i.Item_id
JOIN SalesDB.Stored_items si ON oi.Item_id = si.Item_id
JOIN SalesDB.Stores s ON si.Store_id = s.Store_id
JOIN SalesDB.Headquarters h ON s.City_id = h.City_id;



-- que6
SELECT c.Customer_name, h.City_name, h.State
FROM HeadquarterDB.Customer c
JOIN SalesDB.Headquarters h ON c.City_id = h.City_id
WHERE c.Customer_id = 2
;

	
-- que7
SELECT s.Store_id, h.City_name, i.Description, SUM(si.Quantity_held) AS Total_Stock
FROM SalesDB.Stored_items si
JOIN SalesDB.Stores s ON si.Store_id = s.Store_id
JOIN SalesDB.Headquarters h ON s.City_id = h.City_id
JOIN SalesDB.Items i ON si.Item_id = i.Item_id
WHERE h.City_id = 103 AND si.Item_id = 104
GROUP BY s.Store_id, h.City_name, i.Description;


-- que8
SELECT o.Order_no, i.Description, oi.Quantity_ordered, c.Customer_name, s.Store_id, h.City_name
FROM SalesDB.Ordered_item oi
JOIN SalesDB.Orders o ON oi.Order_no = o.Order_no
JOIN SalesDB.Items i ON oi.Item_id = i.Item_id
JOIN HeadquarterDB.Customer c ON o.Customer_id = c.Customer_id
JOIN SalesDB.Stored_items si ON oi.Item_id = si.Item_id
JOIN SalesDB.Stores s ON si.Store_id = s.Store_id
JOIN SalesDB.Headquarters h ON s.City_id = h.City_id;


-- que9
-- 	 
SELECT c.Customer_id, c.Customer_name, w.tourism_guide
FROM HeadquarterDB.Walk_in_customers w
JOIN HeadquarterDB.Customer c ON w.Customer_id = c.Customer_id;


-- 2  Mail-order Customers
SELECT c.Customer_id, c.Customer_name, m.post_address
FROM HeadquarterDB.Mail_order_customers m
JOIN HeadquarterDB.Customer c ON m.Customer_id = c.Customer_id;

-- 3 Dual Customers (Both Walk-in and Mail-order
SELECT c.Customer_id, c.Customer_name
FROM HeadquarterDB.Walk_in_customers w
JOIN HeadquarterDB.Mail_order_customers m ON w.Customer_id = m.Customer_id
JOIN HeadquarterDB.Customer c ON w.Customer_id = c.Customer_id;


