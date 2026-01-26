CREATE DATABASE CompanyDB;
USE CompanyDB;

CREATE TABLE Department (
    dept_id      INT PRIMARY KEY,
    dept_name    VARCHAR(50) NOT NULL UNIQUE,
    location     VARCHAR(50) NOT NULL
);

CREATE TABLE Employee (
    emp_id       INT PRIMARY KEY,
    emp_name     VARCHAR(50) NOT NULL,
    email        VARCHAR(100) NOT NULL UNIQUE,
    salary       DECIMAL(10,2) NOT NULL,
    hire_date    DATE NOT NULL,
    dept_id      INT NOT NULL,
    CONSTRAINT fk_emp_dept
        FOREIGN KEY (dept_id)
        REFERENCES Department(dept_id),
    CONSTRAINT chk_salary
        CHECK (salary >= 10000)
);

CREATE TABLE Project (
    proj_id      INT PRIMARY KEY,
    proj_name    VARCHAR(100) NOT NULL UNIQUE,
    start_date   DATE NOT NULL,
    end_date     DATE,
    dept_id      INT NOT NULL,
    CONSTRAINT fk_proj_dept
        FOREIGN KEY (dept_id)
        REFERENCES Department(dept_id),
    CONSTRAINT chk_dates
        CHECK (end_date IS NULL OR end_date >= start_date)
);
INSERT INTO Department (dept_id, dept_name, location) VALUES
(10, 'HR','Head Office'),
(20, 'IT','Head Office'),
(30, 'Finance','Branch A');

INSERT INTO Employee (emp_id, emp_name, email, salary, hire_date, dept_id) VALUES
(1, 'Amit Kumar',   'amitkumar@gmail.com',   35000, '2023-04-10', 20),
(2, 'Priyanka chandwani', 'priyanka@gmail.com', 45000, '2022-11-01', 30),
(3, 'Rohit Singh',  'rohitsingh@gmail.com',  30000, '2024-02-15', 10);

INSERT INTO Project (proj_id, proj_name, start_date, end_date, dept_id) VALUES
(101, 'Payroll System',      '2024-01-01', NULL,        30),
(102, 'Intranet Upgrade',    '2024-03-01', '2024-09-30',20),
(103, 'Recruitment Portal',  '2024-05-15', NULL,        10);

UPDATE Employee
SET salary = salary * 1.10
WHERE dept_id = 20;

DELETE FROM Employee
WHERE dept_id = 10;

CREATE user manager with password Manager@123;

GRANT SELECT ON Department TO manager;
GRANT SELECT ON Employee TO manager;
GRANT SELECT ON Project TO manager;
REVOKE CREATE ON SCHEMA public FROM manager;
REVOKE INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public FROM manager;

ALTER TABLE Employee
ADD phone_no VARCHAR(15);

DROP TABLE Project;




