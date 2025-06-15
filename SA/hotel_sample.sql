-- Truncate all tables
TRUNCATE TABLE Hotel.service_detail;
TRUNCATE TABLE Hotel.item;
TRUNCATE TABLE Hotel.service;
TRUNCATE TABLE Hotel.Employee;
TRUNCATE TABLE Hotel.category;
TRUNCATE TABLE Hotel.Booking_Guest;
TRUNCATE TABLE Hotel.booking;
TRUNCATE TABLE Hotel.room;
TRUNCATE TABLE Hotel.room_status;
TRUNCATE TABLE Hotel.Guest;
TRUNCATE TABLE Hotel.tier;
TRUNCATE TABLE Hotel.Country;

-- Populate Hotel.Country
INSERT INTO Hotel.Country (country_id, country_name, country_code) VALUES
(1, 'United States', 'US'),
(2, 'United Kingdom', 'UK'),
(3, 'Canada', 'CA'),
(4, 'Australia', 'AU'),
(5, 'Germany', 'DE');

-- Populate Hotel.tier
INSERT INTO Hotel.tier (tier_id, type, points_to_reach, discount_per_service, discount_per_booking) VALUES
(1, 'Bronze', 0, 0.00, 0.00),
(2, 'Silver', 1000, 5.00, 5.00),
(3, 'Gold', 5000, 10.00, 10.00),
(4, 'Platinum', 10000, 15.00, 15.00);

-- Populate Hotel.Guest
INSERT INTO Hotel.Guest (guest_id, tier_id, country_id, national_code, first_name, last_name, phone_number, email, address, points) VALUES
(1, 2, 1, 'N12345', 'John', 'Doe', '555-1234', 'john.doe@email.com', '123 Main St, Anytown, USA', 1500),
(2, 3, 2, 'N67890', 'Jane', 'Smith', '555-5678', 'jane.smith@email.com', '456 Oak Ave, London, UK', 6000),
(3, 1, 3, 'N11223', 'Peter', 'Jones', '555-9012', 'peter.jones@email.com', '789 Pine Ln, Toronto, CA', 500),
(4, 4, 4, 'N44556', 'Mary', 'Williams', '555-3456', 'mary.williams@email.com', '321 Elm St, Sydney, AU', 12000),
(5, 2, 5, 'N77889', 'Hans', 'Schmidt', '555-7890', 'hans.schmidt@email.com', '654 Birch Rd, Berlin, DE', 2500);

-- Populate Hotel.room_status
INSERT INTO Hotel.room_status (status_id, status_name, description) VALUES
(1, 'Available', 'Room is clean and ready for a new guest.'),
(2, 'Occupied', 'Room is currently occupied by a guest.'),
(3, 'Out of Order', 'Room is not available due to maintenance.'),
(4, 'Cleaning', 'Room is currently being cleaned.');

-- Populate Hotel.room
INSERT INTO Hotel.room (room_id, capacity, floor, room_number, number_of_single_bed, number_of_double_bed, cost_per_day, status_id) VALUES
(101, 2, 1, 101, 0, 1, 150.00, 1),
(102, 2, 1, 102, 2, 0, 120.00, 2),
(201, 4, 2, 201, 2, 1, 250.00, 1),
(202, 1, 2, 202, 1, 0, 100.00, 3),
(301, 3, 3, 301, 1, 1, 200.00, 4);

-- Populate Hotel.booking
INSERT INTO Hotel.booking (booking_id, guest_id, checkin_time, checkout_time, primary_guest_id, room_id, total_charge, total_discount) VALUES
(1, 2, '2025-06-12 09:00:00', NULL, 2, 102, 600.00, 60.00),
(2, 1, '2025-06-11 09:00:00', '2025-06-12 10:00:00', 1, 101, 600.00, 30.00),
(3, 4, '2025-06-8 12:00:00', '2025-06-9 12:00:00', 4, 201, 1250.00, 187.50);

-- Populate Hotel.Booking_Guest
INSERT INTO Hotel.Booking_Guest (booking_id, guest_id) VALUES
(1, 2),
(2, 1),
(3, 4);

-- Populate Hotel.category
INSERT INTO Hotel.category (category_id, category_name, description) VALUES
(1, 'Food', 'Edible items.'),
(2, 'Beverage', 'Drinkable items.'),
(3, 'Laundry', 'Laundry services.'),
(4, 'Spa', 'Spa and wellness services.');

-- Populate Hotel.Employee
INSERT INTO Hotel.Employee (employee_id, national_code, birthday, first_name, last_name, phone_number, address, salary, hire_date, is_active, gender) VALUES
(1, 'E123', '1990-05-15', 'Mike', 'Johnson', '555-1111', '111 Hotel St', 3000.00, '2022-01-10', 1, 'Male'),
(2, 'E456', '1985-08-20', 'Susan', 'Lee', '555-2222', '222 Hotel St', 2500.00, '2021-03-15', 1, 'Female'),
(3, 'E789', '1995-02-28', 'David', 'Chen', '555-3333', '333 Hotel St', 2000.00, '2023-07-01', 1, 'Male');

-- Populate Hotel.service
INSERT INTO Hotel.service (service_id, employee_id, room_id, time, duration_to_complete, type, description) VALUES
(1, 2, 102, '2025-06-12 10:00:00', 30, 'Room Service', 'Breakfast delivery'),
(2, 3, 101, '2025-06-11 14:00:00', 60, 'Cleaning', 'Full room cleaning'),
(3, 1, 201, '2025-06-9 10:00:00', 45, 'Room Service', 'Dinner delivery');

-- Populate Hotel.item
INSERT INTO Hotel.item (item_id, item_name, category_id, cost, charge, duration_to_prepare, description) VALUES
(1, 'Cheeseburger', 1, 5.00, 15.00, 15, 'Classic cheeseburger with fries.'),
(2, 'Coca-Cola', 2, 1.00, 3.00, 1, '330ml can of Coca-Cola.'),
(3, 'T-shirt Laundry', 3, 2.00, 5.00, 120, 'Laundry service for one t-shirt.'),
(4, 'Full Body Massage', 4, 50.00, 100.00, 60, '60-minute full body massage.');

-- Populate Hotel.service_detail
INSERT INTO Hotel.service_detail (service_detail_id, service_id, item_id, quantity) VALUES
(1, 1, 1, 2),
(2, 1, 2, 2),
(3, 3, 1, 1),
(4, 2, 1, 1);


-- select * from dw.hotel.dim_employee
-- select * from sa.hotel.room
-- update hotel.room set cost_per_day=1
-- update hotel.employee set salary=10 
exec dw.hotel.main_proc_first_load
 exec dw.hotel.main_proc
-- -- select * from dw.hotel.dim_room
--update sa.hotel.room set cost_per_day=111
-- update sa.hotel.employee set salary=11
-- select * from dw.hotel.fact_transactional_service
-- select * from dw.hotel.fact_transactional_booking
-- select * from dw.hotel.fact_daily_hotel

-- select * from dw.hotel.dim_employee

select * from dw.hotel.fact_acc_hotel


