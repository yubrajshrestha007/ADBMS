--1. Table Creation
-- Employee and Emp_log Tables
CREATE TABLE Employee (
    EmployeeId NUMBER,
    Log_date   DATE,
    Salary     NUMBER
);

CREATE TABLE Emp_log (
    Emp_id      NUMBER,
    Log_date    DATE,
    Old_salary  NUMBER,
    Action      VARCHAR2(20)
);

-- 2. Statement-Level Trigger
-- Trigger: EmployeeCount
CREATE OR REPLACE TRIGGER EmployeeCount
AFTER INSERT ON Employee
DECLARE
    n INTEGER;
BEGIN
    SELECT COUNT(*) INTO n FROM Employee;
    DBMS_OUTPUT.PUT_LINE('There are now ' || n || ' employees.');
END;
/
-- In SQL*Plus, you can enable output with the following command:
SET SERVEROUTPUT ON SIZE 30000;

-- Test Statement-Level Trigger
INSERT INTO Employee VALUES (1, SYSDATE, 2000);
-- Output: There are now 1 employees.


-- 3. Row-Level Trigger
-- Trigger: EmpSalaryLog
CREATE OR REPLACE TRIGGER EmpSalaryLog
BEFORE UPDATE OF Salary ON Employee
FOR EACH ROW
WHEN (OLD.Salary < 10000)
BEGIN
    INSERT INTO Emp_log
    VALUES (:NEW.EmployeeId, SYSDATE, :OLD.Salary, 'old salary');
END;
/
-- Test Row-Level Trigger
-- Update triggers log if OLD salary < 10000
UPDATE Employee SET Salary = 40000 WHERE EmployeeId = 1;

-- Check log table
SELECT * FROM Emp_log;
