CREATE TABLE Departments (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50)
);

CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50),
    DeptID INT,
    Salary NUMERIC(10,2),
    Status VARCHAR(10),
    FOREIGN KEY (DeptID) REFERENCES Departments(DeptID)
);

INSERT INTO Departments VALUES
(1,'IT'),
(2,'HR'),
(3,'Finance');

INSERT INTO Employees VALUES
(101,'Amit',1,50000,'Active'),
(102,'Neha',2,45000,'Inactive'),
(103,'Rahul',1,60000,'Active'),
(104,'Pooja',3,70000,'Active');

select * from Departments;
select * from Employees;

--step1 : creating simple view
CREATE VIEW ActiveEmployees AS
SELECT EmpID, EmpName, DeptID, Salary
FROM Employees
WHERE Status = 'Active';

select * from ActiveEmployees;

--step 2 : Creating a View for Joining Multiple Tables

CREATE VIEW EmpDeptView AS
SELECT 
    e.EmpID,
    e.EmpName,
    d.DeptName,
    e.Salary
FROM Employees e
JOIN Departments d ON e.DeptID = d.DeptID;

SELECT * FROM EmpDeptView;

--Step 3: Advanced Summarization View

CREATE VIEW DeptSalaryStats AS
SELECT 
    d.DeptName,
    COUNT(e.EmpID) AS TotalEmployees,
    SUM(e.Salary) AS TotalSalary,
    AVG(e.Salary) AS AvgSalary
FROM Employees e
JOIN Departments d ON e.DeptID = d.DeptID
GROUP BY d.DeptName;

SELECT * FROM DeptSalaryStats;