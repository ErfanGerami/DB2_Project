create schema Restaurant;
CREATE TABLE Restaurant.category (
    category_id INT,
    category_name VARCHAR(100)  ,
    description TEXT
);

CREATE TABLE Restaurant.[role] (
    role_id INT,
    role_name VARCHAR(50) ,
    description TEXT
);

CREATE TABLE Restaurant.Employee (
    employee_id INT ,
	national_code varchar(20),
	birthday DATE,
    role_id INT ,
    name VARCHAR(50) ,
    last_name VARCHAR(50) ,
    phone_number VARCHAR(20),
    address TEXT,
    salary DECIMAL(10, 2),
    hire_date DATE,
	is_active BIT,
	gender varcahr(6),
   
);

CREATE TABLE Restaurant.[table] (
    table_id INT ,
    capacity INT ,
    location VARCHAR(100),
    number SMALLINT 
);

CREATE TABLE Restaurant.food (
    food_id INT,
    food_name VARCHAR(100) ,
    category_id INT,
    time_to_prepare INT, 
    meal VARCHAR(50), 
    cooking_method VARCHAR(100),
    cost DECIMAL(10, 2), 
    ingrediant_cost DECIMAL(10, 2), 
    first_served date,
     tax decimal(10,2)
);

CREATE TABLE Restaurant.[order] ( 
    order_id INT ,
    table_id INT ,
    employee_id INT ,
	order_date DATETIME ,
);

CREATE TABLE Restaurant.order_details (
    order_detail_id INT ,
    order_id INT NOT NULL,
    food_id INT NOT NULL,
    quantity INT NOT NULL,
);










create SCHEMA Hotel;

create table Hotel.Country(
    country_id INT,
    country_name VARCHAR(100),
    country_code VARCHAR(10)
);  

create table Hotel.tier (
    tier_id INT,
    type VARCHAR(50),
    points_to_reach INT,
    discount_for_service DECIMAL(5,2),
    discount_for_stay DECIMAL(5,2)
);

create table Hotel.Guest(
    guest_id INT,
    tier_id INT,
    country_id INT,
    national_code VARCHAR(20),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone_number VARCHAR(20),
    email VARCHAR(100),
    address TEXT,
    points INT
);

create table Hotel.room_status(
    status_id INT,
    status_name VARCHAR(50),
    description TEXT
);

create table Hotel.room(
    room_id INT,
    capacity SMALLINT,
    floor INT,
    room_number INT,
    number_of_single_bed INT,
    number_of_double_bed INT,
    cost_per_day DECIMAL(10, 2),
    status_id INT
);
create table Hotel.booking(
    booking_id INT,
    guest_id INT,
    checkin_time DATETIME,
    checkout_time DATETIME,
    primary_guest_id INT,
    room_id INT,
    total_charge DECIMAL(10, 2),
    total_discount DECIMAL(10, 2),
);

create table Hotel.Booking_Guest(
    booking_id INT,
    guest_id INT
);

create table Hotel.category(
    category_id INT,
    category_name VARCHAR(100),
    description TEXT
);

create table Hotel.Employee(
    employee_id INT,
    national_code VARCHAR(20),
    birthday DATE,
    role_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone_number VARCHAR(20),
    address TEXT,
    salary DECIMAL(10, 2),
    hire_date DATE,
    is_active BIT,
    gender VARCHAR(6)
);

create table Hotel.service (
    service_id INT,
    employee_id INT,
    room_id INT,
    time DATETIME,
    duration_to_complete INT,
    type VARCHAR(50),
    description TEXT
);
create table Hotel.item(
    item_id INT,
    item_name VARCHAR(100),
    category_id INT,
    cost DECIMAL(10, 2),
    charge DECIMAL(10, 2),
    duration_to_prepare INT,
    description TEXT,
);


create table Hotel.service_detail (
    service_detail_id INT,
    service_id INT,
    item_id INT,
    quantity INT
);



CREATE table Log(
    procedure_name VARCHAR(100),
    time datetime,
    description TEXT,
    effected_table VARCHAR(100),
    number_of_rows INT
);