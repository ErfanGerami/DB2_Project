-- Truncate all tables in the correct order
TRUNCATE TABLE Restaurant.order_details;
TRUNCATE TABLE Restaurant.[order];
TRUNCATE TABLE Restaurant.food;
TRUNCATE TABLE Restaurant.[table];
TRUNCATE TABLE Restaurant.Employee;
TRUNCATE TABLE Restaurant.[role];
TRUNCATE TABLE Restaurant.category;

DBCC CHECKIDENT ('dw.[restaurant].[dim_food]', RESEED, 0);


-- Insert sample categories
INSERT INTO Restaurant.category (category_id, category_name, description)
VALUES 
(1, 'Appetizers', 'Starters before the main course'),
(2, 'Main Course', 'Main dishes'),
(3, 'Desserts', 'Sweet dishes');



-- Insert roles
INSERT INTO Restaurant.[role] (role_id, role_name, description)
VALUES 
(1, 'Chef', 'Prepares food'),
(2, 'Waiter', 'Serves food'),
(3, 'Manager', 'Manages restaurant');

-- Insert employees
INSERT INTO Restaurant.Employee (employee_id, national_code, birthday, role_id, name, last_name, phone_number, address, salary, hire_date, is_active, gender)
VALUES
(1, '1234567890', '1990-05-01', 1, 'Ali', 'Ahmadi', '09121234567', 'Tehran', 8000.00, '2022-01-01', 1, 'male'),
(2, '0987654321', '1988-08-15', 2, 'Sara', 'Karimi', '09129876543', 'Shiraz', 5000.00, '2023-03-15', 1, 'female');

-- Insert tables
INSERT INTO Restaurant.[table] (table_id, capacity, location, number)
VALUES 
(1, 4, 'Window', 101),
(2, 2, 'Center', 102);

-- Insert food items
INSERT INTO Restaurant.food (food_id, food_name, category_id, time_to_prepare, meal, cooking_method, cost, ingrediant_cost, first_served, tax)
VALUES
(5, 'Cheeseburger', 2, 15, 'Lunch', 'Grilled', 10.00, 5.00, DATEADD(DAY, -4, CAST(GETDATE() AS DATE)), 0.80),
(2, 'French Fries', 1, 10, 'Snack', 'Fried', 5.00, 2.00, DATEADD(DAY, -3, CAST(GETDATE() AS DATE)), 0.40),
(3, 'Chocolate Cake', 3, 25, 'Dessert', 'Baked', 7.00, 3.00, DATEADD(DAY, -2, CAST(GETDATE() AS DATE)), 0.60);

-- Insert orders for 4 previous days
INSERT INTO Restaurant.[order] (order_id, table_id, employee_id, order_date)
VALUES 
(1, 1, 2, DATEADD(DAY, -4, GETDATE())),
(5, 1, 2, DATEADD(DAY, -4, GETDATE())),
(2, 2, 2, DATEADD(DAY, -3, GETDATE())),
(3, 1, 2, DATEADD(DAY, -2, GETDATE())),
(4, 2, 2, DATEADD(DAY, -1, GETDATE()));

-- Insert order details
INSERT INTO Restaurant.order_details (order_detail_id, order_id, food_id, quantity)
VALUES 
(1, 1, 1, 2),
(7, 5, 1, 2),
(2, 1, 2, 1),
(3, 2, 2, 3),
(4, 3, 3, 1),
(5, 4, 1, 1),
(6, 4, 3, 2);

-- select min(order_date) from restaurant.[order]
-- select *  from dw.restaurant.fact_transactional_restaurant
-- select food_key,food_id,category_id,tax,ingrediant_cost,cost from dw.restaurant.dim_food where current_flag=1
-- select * from Restaurant.order_details
-- select * from Restaurant.food
truncate table dw.restaurant.update_log
select * from Restaurant.order_details
select * from dw.Restaurant.fact_transactional_restaurant order by date_id
select * from dw.Restaurant.fact_daily_restaurant where food_key=1
select * from dw.Restaurant.fact_acc_restaurant
update Restaurant.Employee set salary=10
update Restaurant.food set cost=40, ingrediant_cost=30 where food_id=1
-- select * from dw.Restaurant.dim_food
select * from dw.Restaurant.dim_food
select * from dw.hotel.fact_acc_hotel
select * from dw.hotel.fact_transactional_booking
delete dw.restaurant.dim_table where number>100
select * from Restaurant.dim_employee
select * from dw.hotel.dim_employee
update sa.hotel.employee set salary=1111
exec dw.hotel.main_proc



select count(*) from sa.restaurant.[ORDER]



select count(*) from Source.restaurant.[ORDER] 