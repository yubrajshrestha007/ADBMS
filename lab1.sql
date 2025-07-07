-- 1. Country Table
CREATE TABLE Country (
    CountryId INT PRIMARY KEY,
    Name NVARCHAR(100)
);

-- 2. Address Table
CREATE TABLE Address (
    AddressId INT PRIMARY KEY,
    City NVARCHAR(100),
    Street NVARCHAR(200),
    CountryId INT FOREIGN KEY REFERENCES Country(CountryId)
);

-- 3. Customer Table
CREATE TABLE Customer (
    CustomerId INT PRIMARY KEY,
    AddressRef_Id INT FOREIGN KEY REFERENCES Address(AddressId),
    Name NVARCHAR(100),
    Address NVARCHAR(200),
    EmailAddress NVARCHAR(150),
    PhoneNumber NVARCHAR(20)
);

-- 4. ProductCategory Table
CREATE TABLE ProductCategory (
    CategoryId INT PRIMARY KEY,
    CategoryName NVARCHAR(100)
);

-- 5. Product Table
CREATE TABLE Product (
    ProductId INT PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Quantity INT,
    Discount DECIMAL(5,2),
    Price DECIMAL(10,2) CHECK (Price >= 0),
    ProductCategoryRef_Id INT FOREIGN KEY REFERENCES ProductCategory(CategoryId),
    CreatedDate DATE,
    ProductCode NVARCHAR(50) UNIQUE
);

-- 6. PurchaseOrder Table
CREATE TABLE PurchaseOrder (
    PurchaseOrderId INT PRIMARY KEY,
    ProductRef_Id INT FOREIGN KEY REFERENCES Product(ProductId),
    CustomerRef_Id INT FOREIGN KEY REFERENCES Customer(CustomerId),
    OrderDate DATE,
    PaymentTotal DECIMAL(10,2),
    OrderQuantity INT
);
GO
-- Country
INSERT INTO Country VALUES (1, 'Nepal');

-- Address
INSERT INTO Address VALUES (101, 'Kathmandu', 'New Road', 1);

-- Customer
INSERT INTO Customer VALUES (1, 101, 'Yubraj Shrestha', 'Bagbazar', 'yubraj@mail.com', '9800000000');

-- ProductCategory
INSERT INTO ProductCategory VALUES (10, 'Electronics');

-- Product
INSERT INTO Product VALUES (1001, 'Laptop', 10, 5.00, 95000.00, 10, '2024-07-01', 'P-LTP-1001');
INSERT INTO Product VALUES (1002, 'Mouse', 30, 2.00, 1500.00, 10, '2024-07-02', 'P-MSE-1002');

-- PurchaseOrder
INSERT INTO PurchaseOrder VALUES (501, 1001, 1, '2024-07-03', 95000.00, 1);
INSERT INTO PurchaseOrder VALUES (502, 1002, 1, '2024-07-03', 3000.00, 2);
-- aggregate functions on Product table
-- 1. Get maximum, minimum, and average price of products
SELECT
    MAX(Price) AS MaxPrice,
    MIN(Price) AS MinPrice,
    AVG(Price) AS AvgPrice
FROM Product;

-- Grouping: Total Price and Count per Product Category
SELECT
    ProductCategoryRef_Id AS CategoryId,
    COUNT(*) AS ProductCount,
    SUM(Price) AS TotalPrice
FROM Product
GROUP BY ProductCategoryRef_Id;


--INNER JOIN: Product Name and Category Name
SELECT
    p.Name AS ProductName,
    pc.CategoryName
FROM Product p
INNER JOIN ProductCategory pc
ON p.ProductCategoryRef_Id = pc.CategoryId;

--LEFT OUTER JOIN: Show all products with their categories (if any)
SELECT
    p.Name AS ProductName,
    p.Price,
    pc.CategoryName
FROM Product p
LEFT JOIN ProductCategory pc
ON p.ProductCategoryRef_Id = pc.CategoryId
ORDER BY p.Name;

-- View: Total Order Amount and Order Count Per Customer
CREATE VIEW CustomerOrderSummary AS
SELECT
    c.CustomerId,
    c.Name,
    COUNT(po.PurchaseOrderId) AS TotalOrders,
    SUM(po.PaymentTotal) AS TotalAmount
FROM Customer c
LEFT JOIN PurchaseOrder po ON c.CustomerId = po.CustomerRef_Id
GROUP BY c.CustomerId, c.Name;

--to view the result of the view
SELECT * FROM CustomerOrderSummary;
