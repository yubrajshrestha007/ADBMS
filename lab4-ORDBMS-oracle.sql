
sqlplus adbms_user/adbms123@localhost/XEPDB1

1
CREATE OR REPLACE TYPE PhoneList_vartyp AS VARRAY(10) OF VARCHAR2(20);
/
2
CREATE OR REPLACE TYPE Address_objtyp AS OBJECT (
    Street VARCHAR2(200),
    City   VARCHAR2(200)
);
/

3
CREATE OR REPLACE TYPE Customer_objtyp AS OBJECT (
    CustNo        NUMBER,
    CustName      VARCHAR2(200),
    Address_obj   Address_objtyp,
    PhoneList_var PhoneList_vartyp,

    MEMBER FUNCTION getCustNo RETURN NUMBER
) NOT FINAL;
/
4
CREATE OR REPLACE TYPE BODY Customer_objtyp AS
    MEMBER FUNCTION getCustNo RETURN NUMBER IS
    BEGIN
        RETURN CustNo;
    END;
END;
/
5
CREATE TABLE Customer_objtab OF Customer_objtyp (
    CustNo PRIMARY KEY
) OBJECT IDENTIFIER IS PRIMARY KEY;

6
CREATE OR REPLACE TYPE PurchaseOrderO AS OBJECT (
    OrderId   NUMBER,
    OrderDate DATE,
    Cust_Ref  REF Customer_objtyp
);
/

7
CREATE TABLE POrderT OF PurchaseOrderO (
  PRIMARY KEY (OrderId),
  FOREIGN KEY (Cust_Ref) REFERENCES Customer_objtab
)
OBJECT IDENTIFIER IS PRIMARY KEY;

8
-- Insert a customer
INSERT INTO Customer_objtab VALUES (
  Customer_objtyp(
    123,
    'Yubraj Shrestha',
    Address_objtyp('New Road', 'Kathmandu'),
    PhoneList_vartyp('9800000000', '9810000001')
  )
);

-- Insert a purchase order referencing the customer
INSERT INTO POrderT
SELECT 10, SYSDATE, REF(c)
FROM Customer_objtab c
WHERE c.CustNo = 123;
