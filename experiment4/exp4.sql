--step1
DO $$
BEGIN
    FOR i IN 1..5 LOOP
        RAISE NOTICE 'Iteration number: %', i;
    END LOOP;
END;
$$ ;

--step2
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    employee_name VARCHAR(50),
    salary NUMERIC(10,2)
);
INSERT INTO employees (employee_name, salary) VALUES
('Aman', 40000),
('Bob', 55000),
('Charlie', 48000),
('Danish', 60000),
('priyanka', 52000);

DO $$
DECLARE
    emp_rec RECORD;
BEGIN
    FOR emp_rec IN
        SELECT employee_id, employee_name FROM employees
    LOOP
        RAISE NOTICE 'Employee ID: %, Name: %', emp_rec.employee_id, emp_rec.employee_name;
    END LOOP;
END;
$$;

--step3
DO $$
DECLARE
    counter INT := 1;
BEGIN
    WHILE counter <= 5 LOOP
        RAISE NOTICE 'Counter value: %', counter;
        counter := counter + 1;
    END LOOP;
END;
$$ ;

--step4

DO $$
DECLARE
    counter INT := 1;
BEGIN
    LOOP
        RAISE NOTICE 'Counter value: %', counter;
        counter := counter + 1;
        EXIT WHEN counter > 5;
    END LOOP;
END;
$$ ;

--step5

DO $$
DECLARE
	emp_rec RECORD;
BEGIN
    FOR emp_rec IN
        SELECT employee_id, salary FROM employees
    LOOP
        UPDATE employees
        SET salary = salary * 1.10
        WHERE employee_id = emp_rec.employee_id;

        RAISE NOTICE 'Updated salary for Employee ID: %', emp_rec.employee_id;
    END LOOP;
END;
$$ ;

--step6
DO $$
DECLARE
	emp_rec RECORD;

BEGIN
    FOR emp_rec IN
        SELECT employee_id, salary FROM employees
    LOOP
        IF emp_rec.salary > 50000 THEN
            RAISE NOTICE 'Employee ID % has salary more than 50000', emp_rec.employee_id;
        ELSE
            RAISE NOTICE 'Employee ID % has salary less than 50000', emp_rec.employee_id;
        END IF;
    END LOOP;
END;
$$;

