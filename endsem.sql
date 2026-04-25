-- DROP TABLES (optional, to avoid errors if re-running)
DROP TABLE IF EXISTS Tbl_Supply_logs;
DROP TABLE IF EXISTS Tbl_Orders;
DROP TABLE IF EXISTS Tbl_Suppliers;
DROP TABLE IF EXISTS Tbl_Products;

-- =========================
-- CREATE TABLES
-- =========================

CREATE TABLE Tbl_Products (
    prod_id INT PRIMARY KEY,
    prod_name VARCHAR(100),
    category VARCHAR(50),
    price INT,
    stock_qty INT
);

CREATE TABLE Tbl_Suppliers (
    sup_id INT PRIMARY KEY,
    sup_name VARCHAR(100),
    city VARCHAR(50),
    rating INT
);

CREATE TABLE Tbl_Orders (
    order_id INT PRIMARY KEY,
    prod_id INT,
    cust_id INT,
    order_date DATE,
    qty INT,
    FOREIGN KEY (prod_id) REFERENCES Tbl_Products(prod_id)
);

CREATE TABLE Tbl_Supply_logs (
    log_id INT PRIMARY KEY,
    action_type VARCHAR(20),
    prod_id INT,
    old_qty INT,
    new_qty INT,
    log_time TIMESTAMP,
    FOREIGN KEY (prod_id) REFERENCES Tbl_Products(prod_id)
);

-- =========================
-- INSERT DATA
-- =========================

-- Products
INSERT INTO Tbl_Products VALUES
(501, 'Laptop Pro', 'Electronics', 75000, 15),
(502, 'Ergo Chair', 'Furniture', 15000, 8);

-- Suppliers
INSERT INTO Tbl_Suppliers VALUES
(701, 'NextGen Tech', 'Bangalore', 5),
(702, 'Comfort Hub', 'Mumbai', 4);

-- Orders
INSERT INTO Tbl_Orders VALUES
(9001, 501, 101, '2026-04-20', 1),
(9002, 502, 102, '2026-04-21', 2);

-- Supply Logs
INSERT INTO Tbl_Supply_logs VALUES
(1, 'UPDATE', 501, 20, 15, '2026-04-20 10:00:00');

-- =========================
-- VERIFY
-- =========================

SELECT * FROM Tbl_Products;
SELECT * FROM Tbl_Suppliers;
SELECT * FROM Tbl_Orders;
SELECT * FROM Tbl_Supply_logs;

select p.prod_name ,
case 
when sum(o.qty) is null then '0'
else sum(o.qty)
end as total_quantity
from Tbl_Products p
left join Tbl_Orders o
on o.prod_id=p.prod_id
group by p.prod_id , p.prod_name;

CREATE OR REPLACE FUNCTION check_order_qty()
RETURNS TRIGGER
AS $$
DECLARE
    available_qty INTEGER;
BEGIN
    SELECT stock_qty
    INTO available_qty
    FROM Tbl_Products
    WHERE prod_id = NEW.prod_id;

    IF NEW.qty > available_qty THEN
        RAISE EXCEPTION 'Requested quantity exceeds available stock';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_order
BEFORE INSERT
ON Tbl_Orders
FOR EACH ROW
EXECUTE FUNCTION check_order_qty();

INSERT INTO Tbl_Orders
VALUES (9003, 501, 103, '2026-04-25', 5);

INSERT INTO Tbl_Orders
VALUES (9004, 502, 104, '2026-04-25', 20);