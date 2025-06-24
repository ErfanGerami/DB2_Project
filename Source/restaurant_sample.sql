-- Reset tables and identities
DELETE FROM Restaurant.order_details;
DELETE FROM Restaurant.[order];
DELETE FROM Restaurant.food;
DELETE FROM Restaurant.[table];
DELETE FROM Restaurant.Employee;
DELETE FROM Restaurant.[role];
DELETE FROM Restaurant.category;

-- Reset identities
DBCC CHECKIDENT ('Restaurant.category', RESEED, 0);
DBCC CHECKIDENT ('Restaurant.[role]', RESEED, 0);
DBCC CHECKIDENT ('Restaurant.Employee', RESEED, 0);
DBCC CHECKIDENT ('Restaurant.[table]', RESEED, 0);
DBCC CHECKIDENT ('Restaurant.food', RESEED, 0);
DBCC CHECKIDENT ('Restaurant.[order]', RESEED, 0);
DBCC CHECKIDENT ('Restaurant.order_details', RESEED, 0);


INSERT INTO Restaurant.category (category_name, description)
VALUES
('Appetizers', 'Starters to begin the meal'),
('Main Course', 'Hearty and filling dishes'),
('Desserts', 'Sweet treats after the meal'),
('Beverages', 'Cold and hot drinks'),
('Salads', 'Fresh and healthy salads'),
('Soups', 'Warm and comforting soups'),
('Pasta', 'Italian pasta dishes'),
('Grill', 'Grilled meat and vegetables'),
('Vegan', 'Plant-based meal options'),
('Breakfast', 'Morning meals and dishes');


INSERT INTO Restaurant.[role] (role_name, description)
VALUES
('Chef', 'Responsible for cooking meals'),
('Waiter', 'Serves food to customers'),
('Manager', 'Manages the restaurant operations'),
('Cashier', 'Handles customer payments'),
('Dishwasher', 'Cleans dishes and utensils'),
('Host', 'Greets and seats customers'),
('Sous Chef', 'Assists the head chef'),
('Bartender', 'Prepares and serves drinks'),
('Cleaner', 'Maintains cleanliness'),
('Delivery', 'Delivers food to customers');




INSERT INTO Restaurant.Employee (national_code, birthday, role_id, name, last_name, phone_number, address, salary, hire_date, is_active, is_male)
VALUES
('0011223344', '1990-05-12', 1, 'Ali', 'Rezai', '09121111111', 'Tehran', 6000.00, GETDATE(), 1, 1),
('0011223345', '1985-03-25', 2, 'Sara', 'Karimi', '09121111112', 'Tehran', 3500.00, GETDATE(), 1, 0),
('0011223346', '1992-08-14', 3, 'Reza', 'Ahmadi', '09121111113', 'Shiraz', 7500.00, GETDATE(), 1, 1),
('0011223347', '1994-12-05', 4, 'Niloofar', 'Bayat', '09121111114', 'Mashhad', 3200.00, GETDATE(), 1, 0),
('0011223348', '1996-07-18', 5, 'Hamid', 'Kiani', '09121111115', 'Isfahan', 2800.00, GETDATE(), 1, 1),
('0011223349', '1989-11-22', 6, 'Shirin', 'Moradi', '09121111116', 'Tabriz', 3000.00, GETDATE(), 1, 0),
('0011223350', '1993-06-09', 7, 'Mohammad', 'Ghaffari', '09121111117', 'Qom', 5500.00, GETDATE(), 1, 1),
('0011223351', '1991-09-30', 8, 'Parisa', 'Hosseini', '09121111118', 'Urmia', 4000.00, GETDATE(), 1, 0),
('0011223352', '1995-01-01', 9, 'Saeed', 'Yazdi', '09121111119', 'Karaj', 2700.00, GETDATE(), 1, 1),
('0011223353', '1998-04-15', 10, 'Lida', 'Jafari', '09121111120', 'Rasht', 3200.00, GETDATE(), 1, 0);




INSERT INTO Restaurant.[table] (capacity, location, number)
VALUES
(2, 'Near window', 1),
(4, 'Center hall', 2),
(6, 'Private room', 3),
(2, 'Patio', 4),
(8, 'Main hall', 5),
(4, 'Corner booth', 6),
(2, 'Balcony', 7),
(10, 'Banquet area', 8),
(4, 'Bar counter', 9),
(6, 'Terrace', 10);




INSERT INTO Restaurant.food (food_name, category_id, time_to_prepare, meal, cooking_method, cost, ingrediant_cost, first_served, tax)
VALUES
('Caesar Salad', 5, 10, 'Lunch', 'Tossed', 7.50, 3.00, '2021-06-01', 0.75),
('Beef Burger', 2, 15, 'Lunch', 'Grilled', 12.00, 5.00, '2021-06-01', 1.20),
('Mushroom Soup', 6, 20, 'Dinner', 'Boiled', 6.00, 2.00, '2021-06-01', 0.60),
('Grilled Chicken', 8, 25, 'Dinner', 'Grilled', 15.00, 6.00, '2021-06-01', 1.50),
('Espresso', 4, 5, 'All', 'Brewed', 3.00, 0.50, '2021-06-01', 0.30),
('Vegan Pasta', 9, 20, 'Dinner', 'Boiled', 11.00, 4.00, '2021-06-01', 1.10),
('Pancakes', 10, 15, 'Breakfast', 'Fried', 8.00, 2.50, '2021-06-01', 0.80),
('Lamb Kebab', 8, 30, 'Dinner', 'Grilled', 18.00, 7.00, '2021-06-01', 1.80),
('Chocolate Cake', 3, 10, 'Dessert', 'Baked', 5.00, 1.50, '2021-06-01', 0.50),
('Orange Juice', 4, 5, 'Breakfast', 'Fresh', 4.00, 1.00, '2021-06-01', 0.40);




WITH Numbers AS (
    SELECT TOP (100000) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects a CROSS JOIN sys.all_objects b
),
Employees AS (
    SELECT employee_id, ROW_NUMBER() OVER (ORDER BY employee_id) AS rn
    FROM Restaurant.Employee
),
Tables AS (
    SELECT table_id, ROW_NUMBER() OVER (ORDER BY table_id) AS rn
    FROM Restaurant.[table]
),
RandomOrders AS (
    SELECT
        n,
        -- Cycle through table_id
        t.table_id,
        -- Cycle through employee_id
        e.employee_id,
        -- Random order time in the last 7 days
        DATEADD(MINUTE, -(ABS(CHECKSUM(NEWID()) % 8640 )+24*60+ 1), GETDATE()) AS order_date
    FROM Numbers n
    CROSS APPLY (
        SELECT table_id FROM Tables WHERE rn = ((n.n - 1) % (SELECT COUNT(*) FROM Tables)) + 1
    ) t
    CROSS APPLY (
        SELECT employee_id FROM Employees WHERE rn = ((n.n - 1) % (SELECT COUNT(*) FROM Employees)) + 1
    ) e
)
INSERT INTO Restaurant.[order] (table_id, employee_id, order_date)
SELECT table_id, employee_id, order_date
FROM RandomOrders;



WITH Numbers AS (
    SELECT TOP (1000000) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects a CROSS JOIN sys.all_objects b CROSS JOIN sys.all_objects c
),
MaxOrderId AS (
    SELECT MAX(order_id) AS max_order_id FROM Restaurant.[order]
),
Foods AS (
    SELECT food_id, ROW_NUMBER() OVER (ORDER BY food_id) AS rn
    FROM Restaurant.food
),
RandomDetails AS (
    SELECT
        n,
        -- Assign order_id cyclically
        ((n.n - 1) % (SELECT max_order_id FROM MaxOrderId)) + 1 AS order_id,
        -- Cycle through food_id
        f.food_id,
        -- Quantity between 1 and 5
        CAST((ABS(CHECKSUM(NEWID())) % 5) + 1 AS INT) AS quantity
    FROM Numbers n
    CROSS APPLY (
        SELECT food_id FROM Foods WHERE rn = ((n.n - 1) % (SELECT COUNT(*) FROM Foods)) + 1
    ) f
)
INSERT INTO Restaurant.order_details (order_id, food_id, quantity)
SELECT order_id, food_id, quantity
FROM RandomDetails;





