CREATE TABLE Employee (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50),
    Experience INT,
    PerformanceRating INT,
    Salary DECIMAL(10,2)
);

INSERT INTO Employee VALUES
(1,'Amit',3,4,30000),
(2,'Neha',6,5,55000),
(3,'Rahul',1,3,20000),
(4,'Pooja',8,5,70000);

select * from employee;

-- Simple Cursor for Displaying Data(Step 1)
DO $$
DECLARE
    emp_cursor CURSOR FOR SELECT * FROM Employee;
    emp_row RECORD;
BEGIN
    OPEN emp_cursor;
    LOOP
        FETCH emp_cursor INTO emp_row;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE '% % %', emp_row.EmpID, emp_row.EmpName, emp_row.Salary;
    END LOOP;
    CLOSE emp_cursor;
END $$;

--incrementing salary (Step 2)
DO $$
DECLARE
    emp_cursor CURSOR FOR SELECT * FROM Employee;
    emp_row RECORD;
    increment INT;
BEGIN
    OPEN emp_cursor;
    LOOP
        FETCH emp_cursor INTO emp_row;
        EXIT WHEN NOT FOUND;

        increment := emp_row.Experience * emp_row.PerformanceRating * 1000;

        UPDATE Employee
        SET Salary = Salary + increment
        WHERE EmpID = emp_row.EmpID;
    END LOOP;
    CLOSE emp_cursor;
END $$;
select * from employee;

--Exception Handling (Step 3)

DO $$
DECLARE
    emp_cursor CURSOR FOR SELECT * FROM Employee;
    emp_row RECORD;
BEGIN
    OPEN emp_cursor;

    LOOP
        FETCH emp_cursor INTO emp_row;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE '% % %', emp_row.empid, emp_row.empname, emp_row.salary;
    END LOOP;

    CLOSE emp_cursor;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Cursor Error Occurred';
END $$;