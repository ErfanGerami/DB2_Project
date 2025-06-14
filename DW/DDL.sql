create schema Restaurant;
create schema shared;

CREATE TABLE  Restaurant.dim_category (
    category_id INT,
    category_name VARCHAR(255),
    description TEXT
);


CREATE TABLE  shared.dim_date (
    key_date DATE,
    key_date_shamsi VARCHAR(100),
    year INT,
    year_shamsi VARCHAR(100),
    quarter INT,
    quarter_shamsi VARCHAR(100),
    month INT,
    month_shamsi VARCHAR(100),
    day_weak INT,
    day_weak_shamsi VARCHAR(100)
);


CREATE TABLE  Restaurant.dim_employee (
    employee_id INT ,
    name VARCHAR(50) ,
    last_name VARCHAR(50) ,
    phone_number VARCHAR(20),
	national_code varchar(20),
	birthday DATE,
    role_id INT ,
    role_name VARCHAR(100),
    role_description TEXT,
    address TEXT,
    salary DECIMAL(10, 2),
    previous_salary DECIMAL(10,2),
    effective_date DATE,
    hire_date DATE,
	is_active BIT,
	gender varchar(6),
   
);

SELECT food_key, category_id, date_id, time_id AS Expr1, quantity, total_charge, total_ingridient_cost, total_charge_after_tax, total_tax_amount
FROM     Restaurant.fact_daily_restaurant
WHERE  (date_id >= CAST(? AS date)) AND (date_id < DATEADD([DAY], 1, CAST(? AS date)))


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
    cooking_method VARCHAR(100),
    cost DECIMAL(10,2),
    ingrediant_cost DECIMAL(10,2),
    start_date DATE,
    end_date DATE,
    bits char(2),
    current_flag BIT,
	first_served date
);

select * from Restaurant.dim_food




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
);

CREATE TABLE Restaurant.fact_daily_restaurant (
    food_key INT,
    category_id INT,
    date_id DATE,
    quantity INT,
    total_charge DECIMAL(10,2),
    total_ingridient_cost DECIMAL(10,2),
    total_charge_after_tax DECIMAL(10,2),
    total_tax_amount DECIMAL(10,2)
);

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





create schema hotel;

CREATE TABLE hotel.dim_room (
    room_key INT IDENTITY(1,1),
    room_id INT,
    capacity INT,
    floor INT,
    status_id INT,
    status_name VARCHAR(50),
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
    national_code VARCHAR(20),
    birthday DATE,
    role_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone_number VARCHAR(20),
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
    status_name VARCHAR(50),
    description TEXT
);
CREATE TABLE hotel.dim_guest (
    guest_id INT,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    national_code VARCHAR(20),
    phone_number VARCHAR(20),
    country_id INT,
    country_name VARCHAR(100),
    country_code VARCHAR(10),
    email VARCHAR(255),
    points INT,
    tier_id INT,
    tier_type VARCHAR(100),
    tier_points_to_reach INT,
    discount_for_service DECIMAL(5,2),
    discount_for_stay DECIMAL(5,2)
);
CREATE TABLE dim_tier (
    tier_id INT,
    type VARCHAR(100),
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
    charge DECIMAL(10,2),
    cost DECIMAL(10,2),
    item_count INT,
    discount_amount DECIMAL(10,2)
);

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
);
create table hotel.fact_daily_hotel (
    room_key INT,
    room_id INT,

    room_status_id INT,
    date_id DATE,
    total_service_count INT,
    total_service_cost DECIMAL(10,2),
    total_service_charge DECIMAL(10,2),
    total_service_discount DECIMAL(10,2),    
);

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

create table restaurant.update_log(
    table_name VARCHAR(100),
    time datetime,
    date date,
    DESCRIPTION text
)

