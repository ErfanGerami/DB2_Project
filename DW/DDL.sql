


--create desired partition (change the date values)
CREATE PARTITION FUNCTION pf_by_day (DATE)
AS RANGE LEFT FOR VALUES (
    '2024-01-01', '2024-01-02', '2024-01-03',
    '2024-01-04', '2024-01-05', '2024-01-06',
    '2024-01-07', '2024-01-08', '2024-01-09'
);


create schema Restaurant;
create schema shared;

CREATE TABLE  Restaurant.dim_category (
    category_id INT,
    category_name VARCHAR(255),
    description TEXT
);

CREATE TABLE shared.dim_date (
    date_id DATE ,
    full_date_alternate_key VARCHAR(20),
    persian_full_date_alternate_key VARCHAR(20),
    day_number_of_week INT,
    persian_day_number_of_week INT,
    english_day_name_of_week VARCHAR(20),
    persian_day_name_of_week NVARCHAR(20),
    day_number_of_month INT,
    persian_day_number_of_month INT,
    day_number_of_year INT,
    persian_day_number_of_year INT,
    week_number_of_year INT,
    persian_week_number_of_year INT,
    english_month_name VARCHAR(20),
    persian_month_name NVARCHAR(20),
    month_number_of_year INT,
    persian_month_number_of_year INT,
    calendar_quarter INT,
    persian_calendar_quarter INT,
    calendar_year INT,
    persian_calendar_year INT,
    calendar_semester INT,
    persian_calendar_semester INT
);

-- WITH DateRange AS (
--     SELECT CAST(GETDATE() - 10 AS DATE) AS d
--     UNION ALL
--     SELECT DATEADD(DAY, 1, d)
--     FROM DateRange
--     WHERE d < CAST(GETDATE() + 10 AS DATE)
-- )
-- INSERT INTO shared.dim_date (
--     time_key,
--     full_date_alternate_key,
--     persian_full_date_alternate_key,
--     day_number_of_week,
--     persian_day_number_of_week,
--     english_day_name_of_week,
--     persian_day_name_of_week,
--     day_number_of_month,
--     persian_day_number_of_month,
--     day_number_of_year,
--     persian_day_number_of_year,
--     week_number_of_year,
--     persian_week_number_of_year,
--     english_month_name,
--     persian_month_name,
--     month_number_of_year,
--     persian_month_number_of_year,
--     calendar_quarter,
--     persian_calendar_quarter,
--     calendar_year,
--     persian_calendar_year,
--     calendar_semester,
--     persian_calendar_semester
-- )
-- SELECT
--     d AS time_key,
--     FORMAT(d, 'yyyy/MM/dd') AS full_date_alternate_key,
--     FORMAT(d, 'yyyy/MM/dd') AS persian_full_date_alternate_key,  -- Placeholder
--     DATEPART(WEEKDAY, d) AS day_number_of_week,
--     DATEPART(WEEKDAY, d) AS persian_day_number_of_week,  -- Placeholder
--     DATENAME(WEEKDAY, d) AS english_day_name_of_week,
--     N'شنبه' AS persian_day_name_of_week,  -- Placeholder
--     DAY(d) AS day_number_of_month,
--     DAY(d) AS persian_day_number_of_month,  -- Placeholder
--     DATEPART(DAYOFYEAR, d) AS day_number_of_year,
--     DATEPART(DAYOFYEAR, d) AS persian_day_number_of_year,  -- Placeholder
--     DATEPART(WEEK, d) AS week_number_of_year,
--     DATEPART(WEEK, d) AS persian_week_number_of_year,  -- Placeholder
--     DATENAME(MONTH, d) AS english_month_name,
--     N'فروردین' AS persian_month_name,  -- Placeholder
--     MONTH(d) AS month_number_of_year,
--     MONTH(d) AS persian_month_number_of_year,  -- Placeholder
--     DATEPART(QUARTER, d) AS calendar_quarter,
--     DATEPART(QUARTER, d) AS persian_calendar_quarter,  -- Placeholder
--     YEAR(d) AS calendar_year,
--     YEAR(d) AS persian_calendar_year,  -- Placeholder
--     CASE WHEN DATEPART(QUARTER, d) <= 2 THEN 1 ELSE 2 END AS calendar_semester,
--     CASE WHEN DATEPART(QUARTER, d) <= 2 THEN 1 ELSE 2 END AS persian_calendar_semester  -- Placeholder
-- FROM DateRange
-- OPTION (MAXRECURSION 100);


CREATE TABLE  Restaurant.dim_employee (
    employee_id INT ,
    name VARCHAR(60) ,
    last_name VARCHAR(60) ,
    phone_number VARCHAR(30),
	national_code varchar(30),
	birthday DATE,
    role_id INT ,
    role_name VARCHAR(120),
    role_description TEXT,
    address TEXT,
    salary DECIMAL(10, 2),
    previous_salary DECIMAL(10,2),
    effective_date DATE,
    hire_date DATE,
	is_active BIT,
	gender varchar(6),
   
);


CREATE TABLE  Restaurant.dim_table (
    table_id INT,
    capacity INT,
    location VARCHAR(255),
    number INT
);
CREATE TABLE restaurant.dim_food (
	tax decimal(10,2),
    food_id INT,
	food_key INT IDENTITY(1,1),
    food_name VARCHAR(255),
    category_id INT,
    category_name VARCHAR(255),
    time_to_prepare INT,    
    meal VARCHAR(100),
    cooking_method VARCHAR(120),
    cost DECIMAL(10,2),
    ingrediant_cost DECIMAL(10,2),
    start_date DATE,
    end_date DATE,
    bits char(2),
    current_flag BIT,
	first_served date
);





CREATE TABLE Restaurant.fact_transactional_restaurant (
    food_key INT,
    order_id INT,
    category_id INT,
    employee_id INT,
    date_id DATE,
    table_id INT,
    charge DECIMAL(10,2),
    ingredient_cost DECIMAL(10,2),
    tax_amount DECIMAL(10,2),
    quantity INT,
    after_tax_charge DECIMAL(10,2)
)ON ps_by_day(date_id);

CREATE TABLE Restaurant.fact_daily_restaurant (
    food_key INT,
    category_id INT,
    date_id DATE,
    quantity INT,
    total_charge DECIMAL(10,2),
    total_ingridient_cost DECIMAL(10,2),
    total_charge_after_tax DECIMAL(10,2),
    total_tax_amount DECIMAL(10,2)
)ON ps_by_day(date_id);

CREATE TABLE Restaurant.fact_acc_restaurant (
    food_key INT,
    category_id INT,
    running_quantity INT,
    running_charge DECIMAL(10,2),
    running_ingridient_cost DECIMAL(10,2),
    running_charge_after_tax DECIMAL(10,2),
    runing_tax_amount DECIMAL(10,2),
	max_bough INT,
	number_of_days_in_menu INT
);


create table Restaurant.update_log(
    table_name VARCHAR(100),
    time datetime,
    date date,
    DESCRIPTION text
)


CREATE NONCLUSTERED INDEX idx_dim_date_date_id
ON shared.dim_date(date_id);
CREATE NONCLUSTERED INDEX idx_dim_category_id 
ON Restaurant.dim_category(category_id);
CREATE NONCLUSTERED INDEX idx_dim_employee_id 
ON Restaurant.dim_employee(employee_id);
CREATE NONCLUSTERED INDEX idx_dim_table_id 
ON Restaurant.dim_table(table_id);
CREATE NONCLUSTERED INDEX idx_dim_food_id 
ON Restaurant.dim_food(food_id);

CREATE NONCLUSTERED INDEX idx_dim_food_key 
ON Restaurant.dim_food(food_key);
CREATE NONCLUSTERED INDEX idx_fact_tr_restaurant_date_id 
ON Restaurant.fact_transactional_restaurant(date_id);

CREATE NONCLUSTERED INDEX idx_fact_tr_restaurant_food_key 
ON Restaurant.fact_transactional_restaurant(food_key);

CREATE NONCLUSTERED INDEX idx_fact_tr_restaurant_employee_id 
ON Restaurant.fact_transactional_restaurant(employee_id);
CREATE NONCLUSTERED INDEX idx_fact_daily_restaurant_date_id 
ON Restaurant.fact_daily_restaurant(date_id);













create schema hotel;

CREATE TABLE hotel.dim_room (
    room_key INT IDENTITY(1,1),
    room_id INT,
    capacity INT,
    floor INT,
    status_id INT,
    status_name VARCHAR(60),
    status_description TEXT,
    room_number INT,
    number_of_single_bed INT,
    number_of_double_bed INT,
    cost_per_day DECIMAL(10,2),
    start_date DATE,
    end_date DATE,
    current_flag BIT
);
CREATE TABLE hotel.dim_item (
    item_id INT,
    item_name VARCHAR(255),
    category_id INT,
    category_name VARCHAR(255),
    category_description TEXT,
    duration_to_prepare INT,
    cost DECIMAL(10, 2),
    charge DECIMAL(10, 2),
    description TEXT
);
create table Hotel.dim_employee(
    employee_id INT,
    national_code VARCHAR(30),
    birthday DATE,
    first_name VARCHAR(60),
    last_name VARCHAR(60),
    phone_number VARCHAR(30),
    address TEXT,
    salary DECIMAL(10, 2),
    previous_salary DECIMAL(10,2),
    effective_salary_date DATE,
    hire_date DATE,
    is_active BIT,
    gender VARCHAR(6)
);



create table Hotel.dim_room_status(
    status_id INT,
    status_name VARCHAR(60),
    description TEXT
);
CREATE TABLE hotel.dim_guest (
    guest_id INT,
    first_name VARCHAR(120),
    last_name VARCHAR(120),
    national_code VARCHAR(30),
    phone_number VARCHAR(30),
    country_id INT,
    country_name VARCHAR(120),
    country_code VARCHAR(10),
    email VARCHAR(255),
    points INT,
    tier_id INT,
    tier_type VARCHAR(120),
    tier_points_to_reach INT,
    discount_per_service DECIMAL(5,2),
    discount_per_booking DECIMAL(5,2)
);
CREATE TABLE hotel.dim_tier (
    tier_id INT,
    type VARCHAR(120),
    points_to_reach INT,
    discount_per_service DECIMAL(5,2),
    discount_per_booking DECIMAL(5,2)
);
create table  hotel.fact_transactional_service (
    room_key INT ,
    room_id INT,
    guest_id INT,
    employee_id INT,
    date_id DATE,
    tier_id INT,
    service_id INT,
    booking_id INT,
    item_id INT,
    charge DECIMAL(10,2),
    cost DECIMAL(10,2),
    item_count INT,
    discount_amount DECIMAL(10,2)
)ON ps_by_day(date_id);

create table hotel.fact_transactional_booking (
    room_key INT,
    room_id INT,
    guest_id INT,
    tier_id INT,
    checkin_time DATE,
    checkout_time DATE,
    total_service_cost DECIMAL(10,2),
    total_service_charge DECIMAL(10,2),
    total_service_item_count INT,
    total_room_charge DECIMAL(10,2),
    total_charge DECIMAL(10,2),
    duration_time INT,
    total_service_discount DECIMAL(10,2),
    total_room_discount DECIMAL(10,2),
)ON ps_by_day(date_id);


create table hotel.fact_daily_hotel (
    room_key INT,
    room_id INT,

    room_status_id INT,
    date_id DATE,
    total_service_count INT,
    total_service_cost DECIMAL(10,2),
    total_service_charge DECIMAL(10,2),
    total_service_discount DECIMAL(10,2),    
)ON ps_by_day(date_id);

create table hotel.fact_acc_hotel (
    room_key INT,
    room_id INT,
    room_status_id INT,
    running_service_cost DECIMAL(10,2),
    running_service_charge DECIMAL(10,2),
    running_service_count INT,
    running_service_discount DECIMAL(10,2), 
    running_room_discount DECIMAL(10,2),
    running_room_charge DECIMAL(10,2),
    avg_duration INT,
    running_number_of_bookings INT,
);


CREATE table Log(
    procedure_name VARCHAR(100),
    time datetime,
    description TEXT,
    effected_table VARCHAR(100),
    number_of_rows INT
);



CREATE NONCLUSTERED INDEX idx_dim_room_key 
ON hotel.dim_room(room_key);

CREATE NONCLUSTERED INDEX idx_dim_room_id 
ON hotel.dim_room(room_id);

CREATE NONCLUSTERED INDEX idx_dim_item_id 
ON hotel.dim_item(item_id);
CREATE NONCLUSTERED INDEX idx_dim_employee_id 
ON hotel.dim_employee(employee_id);
CREATE NONCLUSTERED INDEX idx_dim_guest_id 
ON hotel.dim_guest(guest_id);


CREATE NONCLUSTERED INDEX idx_fact_tr_service_date_id 
ON hotel.fact_transactional_service(date_id);

CREATE NONCLUSTERED INDEX idx_fact_tr_service_guest_id 
ON hotel.fact_transactional_service(guest_id);

CREATE NONCLUSTERED INDEX idx_fact_tr_service_item_id 
ON hotel.fact_transactional_service(item_id);
CREATE NONCLUSTERED INDEX idx_fact_daily_hotel_date_id 
ON hotel.fact_daily_hotel(date_id);

