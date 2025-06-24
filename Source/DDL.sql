create schema Restaurant;

CREATE TABLE Restaurant.category (
    category_id INT PRIMARY KEY IDENTITY(1,1),
    category_name VARCHAR(100) NOT NULL,
    description TEXT
);

CREATE TABLE Restaurant.[role] (
    role_id INT PRIMARY KEY IDENTITY(1,1),
    role_name VARCHAR(50) NOT NULL,
    description TEXT
);

CREATE TABLE Restaurant.Employee (
    employee_id INT PRIMARY KEY IDENTITY(1,1),
	national_code varchar(20),
	birthday DATE NOT NULL,
    role_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(20),
    address TEXT NOT NULL,
    salary DECIMAL(10, 2) NOT NULL,
    hire_date DATE NOT NULL,
	is_active BIT NOT NULL,
    is_male BIT NOT NULL,

    FOREIGN KEY (role_id) REFERENCES Restaurant.role(role_id)
);

CREATE TABLE Restaurant.[table] (
    table_id INT PRIMARY KEY IDENTITY(1,1),
    capacity INT NOT NULL,
    location VARCHAR(100),
    number SMALLINT NOT NULL
);

CREATE TABLE Restaurant.food (
    food_id INT PRIMARY KEY IDENTITY(1,1),
    food_name VARCHAR(100) NOT NULL,
    category_id INT ,
    time_to_prepare INT, 
    meal VARCHAR(50), 
    cooking_method VARCHAR(100),
    cost DECIMAL(10, 2) NOT NULL, 
    ingrediant_cost DECIMAL(10, 2) NOT NULL, 
    first_served date NOT NULL,
     tax decimal(10,2) NOT NULL,

    FOREIGN KEY (category_id) REFERENCES Restaurant.category(category_id) ON DELETE CASCADE
);

CREATE TABLE Restaurant.[order] ( 
    order_id INT PRIMARY KEY IDENTITY(1,1),
    table_id INT NOT NULL,
    employee_id INT NOT NULL,
	order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (table_id) REFERENCES Restaurant.[table](table_id) ON DELETE CASCADE,
    FOREIGN KEY (employee_id) REFERENCES Restaurant.Employee(employee_id) ON DELETE CASCADE
);

CREATE TABLE Restaurant.order_details (
    order_detail_id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT NOT NULL,
    food_id INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Restaurant.[order](order_id)ON DELETE CASCADE,
    FOREIGN KEY (food_id) REFERENCES Restaurant.food(food_id) ON DELETE CASCADE
);








create SCHEMA Hotel;

create table Hotel.Country(
    country_id INT PRIMARY KEY IDENTITY(1,1),
    country_name VARCHAR(100) NOT NULL,
    country_code VARCHAR(10) NOT NULL
);  

create table Hotel.tier (
    tier_id INT PRIMARY KEY IDENTITY(1,1),
    type VARCHAR(50),
    points_to_reach INT,
    discount_for_service DECIMAL(5,2),
    discount_for_stay DECIMAL(5,2)
);

create table Hotel.Guest(
    guest_id INT PRIMARY KEY IDENTITY(1,1),
    tier_id INT ,
    country_id INT NOT NULL,
    national_code VARCHAR(20) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(20),
    email VARCHAR(100),
    address TEXT NOT NULL,
    points INT NOT NULL,
    foreign key(tier_id) REFERENCES Hotel.tier(tier_id) ON DELETE SET NULL,
    foreign key(country_id) REFERENCES Hotel.Country(country_id) ON DELETE CASCADE
);

create table Hotel.room_status(
    status_id INT PRIMARY KEY IDENTITY(1,1),
    status_name VARCHAR(50) NOT NULL,
    description TEXT
);

create table Hotel.room(
 room_id INT PRIMARY KEY IDENTITY(1,1) ,
 capacity SMALLINT NOT NULL,
 floor INT NOT NULL,
 room_number INT NOT NULL,
 number_of_single_bed INT NOT NULL,
 number_of_double_bed INT NOT NULL,
 cost_per_day DECIMAL(10, 2) NOT NULL,
 status_id INT NOT NULL,
 FOREIGN KEY (status_id) REFERENCES Hotel.room_status(status_id) ON DELETE CASCADE
);





create table Hotel.booking(
    booking_id INT PRIMARY KEY IDENTITY(1,1),
    checkin_time DATETIME NOT NULL,
    checkout_time DATETIME NOT NULL,
    primary_guest_id INT NOT NULL,
    room_id INT,
    guest_id INT,
    FOREIGN KEY (guest_id) REFERENCES Hotel.Guest(guest_id) ON DELETE SET NULL,
    FOREIGN KEY (primary_guest_id) REFERENCES Hotel.Guest(guest_id) ON DELETE CASCADE,
    FOREIGN KEY (room_id) REFERENCES Hotel.room(room_id) ON DELETE SET NULL
);




create table Hotel.category(
    category_id INT PRIMARY KEY IDENTITY(1,1),
    category_name VARCHAR(100) NOT NULL,
    
    description TEXT
);

create table Hotel.Employee(
    employee_id INT PRIMARY KEY IDENTITY(1,1),
    national_code VARCHAR(20) NOT NULL,
    birthday DATE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(20),
    address TEXT NOT NULL,
    salary DECIMAL(10, 2) NOT NULL,
    hire_date DATE NOT NULL,
    is_active BIT NOT NULL,
    is_male BIT NOT NULL,
    role VARCHAR(50)
);
create table Hotel.item(
    item_id INT PRIMARY KEY IDENTITY(1,1),
    item_name VARCHAR(100),
    category_id INT,
    cost DECIMAL(10, 2),
    charge DECIMAL(10, 2),
    duration_to_prepare INT,
    description TEXT,
    foreign key (category_id) references Hotel.category(category_id)
);
create table Hotel.service (
    service_id INT PRIMARY KEY IDENTITY(1,1),
    employee_id INT ,
    room_id INT,
    duration_to_complete INT NOT NULL,
    time DATETIME,

    type VARCHAR(50),
    description TEXT,
);

create table Hotel.service_detail (
    service_detail_id INT PRIMARY KEY IDENTITY(1,1),
    service_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    FOREIGN KEY (service_id) REFERENCES Hotel.service(service_id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES Hotel.item(item_id) ON DELETE CASCADE
    
);


