-- HOTEL schema
DELETE FROM Hotel.service_detail;
DELETE FROM Hotel.service;
DELETE FROM Hotel.booking;
DELETE FROM Hotel.item;
DELETE FROM Hotel.room;
DELETE FROM Hotel.room_status;
DELETE FROM Hotel.Guest;
DELETE FROM Hotel.tier;
DELETE FROM Hotel.Country;
DELETE FROM Hotel.Employee;
DELETE FROM Hotel.category;
-- Reset identity for tables with IDENTITY columns
DBCC CHECKIDENT ('Hotel.Country', RESEED, 0);
DBCC CHECKIDENT ('Hotel.tier', RESEED, 0);
DBCC CHECKIDENT ('Hotel.Guest', RESEED, 0);
DBCC CHECKIDENT ('Hotel.room_status', RESEED, 0);
DBCC CHECKIDENT ('Hotel.room', RESEED, 0);
DBCC CHECKIDENT ('Hotel.booking', RESEED, 0);
DBCC CHECKIDENT ('Hotel.Employee', RESEED, 0);
DBCC CHECKIDENT ('Hotel.category', RESEED, 0);
DBCC CHECKIDENT ('Hotel.item', RESEED, 0);
DBCC CHECKIDENT ('Hotel.service', RESEED, 0);
DBCC CHECKIDENT ('Hotel.service_detail', RESEED, 0);

INSERT INTO Hotel.Country (country_name, country_code)
VALUES 
('Canada', 'CA'), ('USA', 'US'), ('Germany', 'DE'), 
('France', 'FR'), ('Italy', 'IT'), ('Iran', 'IR'), 
('Japan', 'JP'), ('India', 'IN'), ('Brazil', 'BR'), ('UK', 'UK');

INSERT INTO Hotel.tier (type, points_to_reach, discount_for_service, discount_for_stay)
VALUES 
('Bronze', 0, 0.00, 0.00), 
('Silver', 1000, 5.00, 5.00), 
('Gold', 5000, 10.00, 10.00), 
('Platinum', 10000, 15.00, 20.00),
('Diamond', 20000, 20.00, 30.00);


INSERT INTO Hotel.Guest (tier_id, country_id, national_code, first_name, last_name, phone_number, email, address, points)
VALUES
(1, 1, 'NC12345601', 'Ali', 'Rezaei', '1234567890', 'ali@example.com', 'Tehran', 1200),
(2, 2, 'NC12345602', 'Sara', 'Smith', '2234567890', 'sara@example.com', 'Toronto', 2400),
(3, 3, 'NC12345603', 'Tom', 'Brown', '3234567890', 'tom@example.com', 'Berlin', 3000),
(4, 4, 'NC12345604', 'Emma', 'Jones', '4234567890', 'emma@example.com', 'Paris', 1500),
(5, 5, 'NC12345605', 'Luca', 'Rossi', '5234567890', 'luca@example.com', 'Rome', 6000),
(1, 6, 'NC12345606', 'Nima', 'Ahmadi', '6234567890', 'nima@example.com', 'Shiraz', 500),
(2, 7, 'NC12345607', 'Kenji', 'Tanaka', '7234567890', 'kenji@example.com', 'Tokyo', 800),
(3, 8, 'NC12345608', 'Priya', 'Singh', '8234567890', 'priya@example.com', 'Delhi', 1700),
(4, 9, 'NC12345609', 'Ana', 'Silva', '9234567890', 'ana@example.com', 'Rio', 950),
(5, 10,'NC12345610', 'John', 'Doe', '0334567890', 'john@example.com', 'London', 1100);

INSERT INTO Hotel.room_status (status_name, description)
VALUES 
('Available', 'Ready for booking'), 
('Occupied', 'Currently booked'), 
('Maintenance', 'Under repair'), 
('Cleaning', 'Being cleaned');

INSERT INTO Hotel.room (capacity, floor, room_number, number_of_single_bed, number_of_double_bed, cost_per_day, status_id)
VALUES
(2, 1, 103, 1, 0, 100.00, 1),
(3, 1, 104, 1, 1, 120.00, 1),
(2, 2, 203, 1, 0, 110.00, 2),
(4, 2, 204, 2, 1, 180.00, 1),
(1, 3, 303, 1, 0, 90.00, 3),
(2, 3, 304, 1, 0, 100.00, 1),
(3, 4, 403, 1, 1, 125.00, 1),
(4, 4, 404, 2, 1, 185.00, 2),
(1, 5, 503, 1, 0, 88.00, 1),
(2, 5, 504, 1, 0, 95.00, 1),
(3, 6, 603, 1, 1, 130.00, 2),
(4, 6, 604, 2, 1, 190.00, 1),
(5, 7, 703, 2, 2, 210.00, 1),
(2, 7, 704, 1, 0, 105.00, 3),
(3, 8, 803, 1, 1, 140.00, 1),
(4, 8, 804, 2, 1, 195.00, 1);

INSERT INTO Hotel.Employee (
    national_code, birthday, first_name, last_name, phone_number, address, 
    salary, hire_date, is_active, is_male, [role]
)
VALUES 
('12743185673', '1991-03-10', 'Mehdi', 'Rahimi', '0912000004', 'Tabriz', 4700.00, GETDATE(), 1, 1, 'Cleaner'),
('12743185674', '1988-07-21', 'Reza', 'Azizi', '0912000005', 'Mashhad', 4900.00, GETDATE(), 1, 1, 'Receptionist'),
('12743185675', '1993-09-14', 'Fatemeh', 'Zare', '0912000006', 'Tehran', 4600.00, GETDATE(), 1, 0, 'Service Staff'),
('12743185676', '1995-04-02', 'Elham', 'Safari', '0912000007', 'Shiraz', 4500.00, GETDATE(), 1, 0, 'Room Service'),
('12743185677', '1992-06-17', 'Sina', 'Bahrami', '0912000008', 'Karaj', 5000.00, GETDATE(), 1, 1, 'Chef'),
('12743185678', '1987-12-01', 'Mohammad', 'Fallahi', '0912000009', 'Qom', 5200.00, GETDATE(), 1, 1, 'Security'),
('12743185679', '1990-08-30', 'Nasim', 'Gholami', '0912000010', 'Isfahan', 4750.00, GETDATE(), 1, 0, 'Manager'),
('12743185680', '1989-11-25', 'Parsa', 'Mousavi', '0912000011', 'Rasht', 4800.00, GETDATE(), 1, 1, 'Cleaner'),
('12743185681', '1994-01-19', 'Shirin', 'Kazemi', '0912000012', 'Urmia', 4650.00, GETDATE(), 1, 0, 'Receptionist'),
('12743185682', '1996-05-12', 'Hamed', 'Jafari', '0912000013', 'Arak', 4550.00, GETDATE(), 1, 1, 'Technician');



INSERT INTO Hotel.category (category_name, description)
VALUES
('Cleaning Services', 'Services related to room and facility cleaning'),
('Laundry', 'Laundry and ironing services'),
('Food & Beverage', 'Meals, snacks, and drinks'),
('Spa & Wellness', 'Spa treatments and wellness services'),
('Mini Bar', 'Mini bar snacks and drinks'),
('Room Services', 'General room-related services'),
('Transportation', 'Pickup and drop-off services'),
('Fitness', 'Gym and fitness-related services'),
('Conference & Event', 'Conference room and event services'),
('Special Arrangements', 'Special decoration and requests'),
('Extra Amenities', 'Additional amenities for guests'),
('Baby Services', 'Services for guests with babies'),
('Entertainment', 'In-room entertainment services'),
('Checkout Services', 'Services related to check-in and checkout');


INSERT INTO Hotel.item (item_name, category_id, cost, charge, duration_to_prepare, description)
VALUES
('Room Cleaning', 1, 10.00, 15.00, 30, 'Standard room cleaning service'),
('Laundry Service', 2, 8.00, 12.00, 45, 'Laundry and ironing service'),
('Continental Breakfast', 3, 5.00, 8.00, 20, 'Breakfast meal served in room'),
('Lunch Meal', 3, 12.00, 18.00, 30, 'Variety of lunch meals'),
('Dinner Meal', 3, 15.00, 22.00, 40, 'Dinner with appetizer and dessert'),
('Spa Massage', 4, 60.00, 90.00, 60, 'Therapeutic massage session'),
('Mini Bar Snack', 5, 3.00, 5.00, 5, 'Assorted snacks from mini bar'),
('Room Service Drink', 6, 2.00, 4.00, 10, 'Non-alcoholic drink delivery'),
('Wake-up Call', 6, 0.00, 0.00, 0, 'Personalized wake-up call'),
('Airport Pickup', 7, 25.00, 40.00, 60, 'Transportation from airport'),
('Gym Access', 8, 0.00, 0.00, 0, 'Access to gym facilities'),
('Conference Room Booking', 9, 100.00, 150.00, 0, 'Booking for meetings'),
('Special Decoration', 10, 50.00, 75.00, 120, 'Room decoration for events'),
('Extra Bed', 11, 15.00, 25.00, 0, 'Additional bed in room'),
('Baby Crib', 12, 10.00, 20.00, 0, 'Provision of baby crib'),
('Laundry Pickup', 2, 0.00, 5.00, 15, 'Laundry pickup from room'),
('Vegan Dinner', 3, 17.00, 25.00, 40, 'Special vegan meal option'),
('In-room Movie Rental', 13, 3.00, 5.00, 0, 'Movie rental service'),
('Spa Facial', 4, 45.00, 70.00, 50, 'Facial spa treatment'),
('Late Checkout', 14, 0.00, 20.00, 0, 'Late checkout option');


WITH Numbers AS (
    SELECT TOP (500000) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects a CROSS JOIN sys.all_objects b
),
Employees AS (
    SELECT employee_id, ROW_NUMBER() OVER (ORDER BY employee_id) AS rn
    FROM Hotel.Employee
),
Rooms AS (
    SELECT room_id, ROW_NUMBER() OVER (ORDER BY room_id) AS rn
    FROM Hotel.room
),
RandomTypes AS (
    SELECT 'Cleaning' AS type UNION ALL
    SELECT 'Room Service' UNION ALL
    SELECT 'Food Delivery' UNION ALL
    SELECT 'Maintenance' UNION ALL
    SELECT 'Laundry'
),
RandomTypeCTE AS (
    SELECT type, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn
    FROM RandomTypes
),
RandomizedServices AS (
    SELECT
        n,
        -- Assign employee cyclically
        e.employee_id,
        -- Assign room cyclically
        r.room_id,
        -- Random duration between 10 and 130
        CAST((ABS(CHECKSUM(NEWID())) % 121) + 10 AS INT) AS duration_to_complete,
        -- Random type cyclically
        rt.type,
        -- Description like 'Service #n'
        CONCAT('Service Description ', n) AS description,
        -- Random time within last 6 days
        DATEADD(MINUTE, -(ABS(CHECKSUM(NEWID())) % 8640+24*60+1), GETDATE()) AS time
    FROM Numbers n
    CROSS APPLY (
        SELECT employee_id FROM Employees WHERE rn = ((n.n - 1) % (SELECT COUNT(*) FROM Employees)) + 1
    ) e
    CROSS APPLY (
        SELECT room_id FROM Rooms WHERE rn = ((n.n - 1) % (SELECT COUNT(*) FROM Rooms)) + 1
    ) r
    CROSS APPLY (
        SELECT type FROM RandomTypeCTE WHERE rn = ((n.n - 1) % (SELECT COUNT(*) FROM RandomTypeCTE)) + 1
    ) rt
)
INSERT INTO Hotel.service (employee_id, room_id, duration_to_complete, time, type, description)
SELECT employee_id, room_id, duration_to_complete, time, type, description
FROM RandomizedServices;







WITH Numbers AS (
    SELECT TOP (1000000) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects a CROSS JOIN sys.all_objects b CROSS JOIN sys.all_objects c
),
MaxServiceId AS (
    SELECT MAX(service_id) AS max_service_id FROM Hotel.service
),
Items AS (
    SELECT item_id, ROW_NUMBER() OVER (ORDER BY item_id) AS rn
    FROM Hotel.item
),
RandomizedDetails AS (
    SELECT
        n,
        -- Assign service_id cyclically from 1 to max service id
        ((n.n - 1) % (SELECT max_service_id FROM MaxServiceId)) + 1 AS service_id,
        -- Assign item_id cyclically
        i.item_id,
        -- Quantity between 1 and 10
        CAST((ABS(CHECKSUM(NEWID())) % 10) + 1 AS INT) AS quantity
    FROM Numbers n
    CROSS APPLY (
        SELECT item_id FROM Items WHERE rn = ((n.n - 1) % (SELECT COUNT(*) FROM Items)) + 1
    ) i
)
INSERT INTO Hotel.service_detail (service_id, item_id, quantity)
SELECT service_id, item_id, quantity
FROM RandomizedDetails;







WITH Days AS (
    SELECT TOP (7) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS day_offset
    FROM master.dbo.spt_values
),
Rooms AS (
    SELECT room_id, cost_per_day, ROW_NUMBER() OVER (ORDER BY room_id) AS rn
    FROM Hotel.room
),
Guests AS (
    SELECT guest_id, ROW_NUMBER() OVER (ORDER BY guest_id) AS rn
    FROM Hotel.Guest
),
Combinations AS (
    SELECT 
        r.room_id,
        r.cost_per_day,
        d.day_offset,
        DATEADD(DAY, -d.day_offset, CAST(GETDATE() AS DATE)) AS checkin_time,
        DATEADD(DAY, -d.day_offset + 1, CAST(GETDATE() AS DATE)) AS checkout_time,
        g1.guest_id AS primary_guest_id,
        g2.guest_id AS guest_id
    FROM Rooms r
    CROSS JOIN Days d
    CROSS APPLY (
        SELECT guest_id FROM Guests 
        WHERE rn = ((r.rn + d.day_offset - 2) % (SELECT COUNT(*) FROM Guests)) + 1
    ) g1
    CROSS APPLY (
        SELECT guest_id FROM Guests 
        WHERE rn = ((r.rn + d.day_offset - 1) % (SELECT COUNT(*) FROM Guests)) + 1
    ) g2
)
INSERT INTO Hotel.booking (
    checkin_time, checkout_time, primary_guest_id, room_id, guest_id,
    total_charge, total_discount
)
SELECT 
    checkin_time,
    checkout_time,
    primary_guest_id,
    room_id,
    guest_id,
    cost_per_day,
    cost_per_day*0.5
FROM Combinations
ORDER BY room_id, checkin_time;





