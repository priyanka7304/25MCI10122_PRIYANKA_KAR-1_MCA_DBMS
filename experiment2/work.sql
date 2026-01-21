create table orders (
    order_id serial primary key,
    customer_name varchar(50),
    product varchar(50),
    quantity int,
    price numeric(10,2),
    order_date date
);
insert into orders (customer_name, product, quantity, price, order_date) values
('amit', 'laptop', 1, 65000, '2024-01-10'),
('neha', 'mobile', 2, 40000, '2024-01-12'),
('rohan', 'tablet', 1, 25000, '2024-01-15'),
('simran', 'laptop', 1, 70000, '2024-01-18'),
('ankit', 'mobile', 3, 60000, '2024-01-20'),
('pooja', 'headphones', 2, 5000, '2024-01-22'),
('rahul', 'tablet', 2, 48000, '2024-01-25');

select * from orders where price > 50000;
select customer_name, product, price from orders where price > 30000 and quantity >= 2;

select customer_name, product, price from orders order by price asc;
select customer_name, product, price from orders order by price desc;
select customer_name, product, price, quantity from orders order by product asc, price desc;


select product, sum(price) as total_sales from orders group by product;
select product, sum(quantity) as total_quantity from orders group by product;


select product, sum(price) as total_sales from orders group by product having sum(price) > 50000;

select product, sum(price) from orders group by product having sum(price) > 50000;