CREATE TABLE Department (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL UNIQUE,
    location VARCHAR(50)
);

CREATE TABLE Employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50) NOT NULL,
    salary INT CHECK (salary > 0),
    dept_id INT,
    CONSTRAINT fk_dept
        FOREIGN KEY (dept_id)
        REFERENCES Department(dept_id)
        ON DELETE SET NULL
);

CREATE TABLE Project (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(50) NOT NULL,
    dept_id INT NOT NULL,
    CONSTRAINT fk_project_dept
        FOREIGN KEY (dept_id)
        REFERENCES Department(dept_id)
);

INSERT INTO Department VALUES (1, 'HR', 'Delhi');
INSERT INTO Department VALUES (2, 'IT', 'Bangalore');
INSERT INTO Department VALUES (3, 'Finance', 'Mumbai');

INSERT INTO Employee VALUES (101, 'Amit', 50000, 2);
INSERT INTO Employee VALUES (102, 'Riya', 45000, 1);
INSERT INTO Employee VALUES (103, 'Karan', 60000, 2);

INSERT INTO Project VALUES (201, 'Payroll System', 1);
INSERT INTO Project VALUES (202, 'Website Upgrade', 2);

UPDATE Employee
SET salary = 55000
WHERE emp_id = 101;

DELETE FROM Department
WHERE dept_id = 3;

CREATE ROLE reporting_staff LOGIN PASSWORD 'reportS1';

GRANT SELECT ON Department TO reporting_staff;
GRANT SELECT ON Employee TO reporting_staff;
GRANT SELECT ON Project TO reporting_staff;

REVOKE CREATE ON SCHEMA public FROM reporting_staff;

ALTER TABLE Employee
ADD email VARCHAR(50);

DROP TABLE Project;

SELECT * FROM employee;