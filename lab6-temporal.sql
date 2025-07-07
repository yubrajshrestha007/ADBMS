-- Temporal Tables in SQL Server
-- SQL server

CREATE TABLE EmployeeTemporal (
    EmployeeId INT PRIMARY KEY,
    Name NVARCHAR(100),
    Salary DECIMAL(10, 2),
    SysStartTime DATETIME2 GENERATED ALWAYS AS ROW START,
    SysEndTime DATETIME2 GENERATED ALWAYS AS ROW END,
    PERIOD FOR SYSTEM_TIME (SysStartTime, SysEndTime)
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.EmployeeTemporalHistory));



-- Insert
INSERT INTO EmployeeTemporal (EmployeeId, Name, Salary)
VALUES (1, 'Yubraj', 30000.00);

-- Update salary (old value will be stored in history)
UPDATE EmployeeTemporal SET Salary = 40000.00 WHERE EmployeeId = 1;


-- Get current record
SELECT * FROM EmployeeTemporal;

-- Get all history (current + past)
SELECT * FROM EmployeeTemporal
FOR SYSTEM_TIME ALL
WHERE EmployeeId = 1;

-- Get salary as of a specific date
SELECT * FROM EmployeeTemporal
FOR SYSTEM_TIME AS OF '2024-06-01T00:00:00'
WHERE EmployeeId = 1;
