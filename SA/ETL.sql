create or alter procedure Hotel.fill_room
as BEGIN

    insert into Log(procedure_name,time,description, effected_table, number_of_rows)
    values('Hotel.fill_room', getdate(), 'start', '', 0);
    truncate table Hotel.room;
    
    insert into Log(procedure_name,time,description, effected_table, number_of_rows)
    values('Hotel.fill_room', getdate(), 'truncate table Hotel.room', 'Hotel.room', @@ROWCOUNT);

    declare @row_count int;
    insert into Hotel.room(room_id, capacity, floor, room_number, number_of_single_bed, number_of_double_bed, cost_per_day, status_id)
    (select room_id, capacity, floor, room_number, number_of_single_bed, number_of_double_bed, cost_per_day, status_id from Source.Hotel.room);
    set @row_count = (select count(*) from Hotel.room);

    insert into Log(procedure_name,time,description, effected_table, number_of_rows)
    values('Hotel.fill_room', getdate(), 'inserting data', 'Hotel.room', @row_count);

    insert into Log(procedure_name,time,description, effected_table, number_of_rows)
    values('Hotel.fill_room', getdate(), 'end', '', 0);
   

END
GO
CREATE OR ALTER PROCEDURE Hotel.Fill_Country
AS
BEGIN
    INSERT INTO Log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES('Hotel.Fill_Country', GETDATE(), 'start', '', 0);

    TRUNCATE TABLE Hotel.Country;
    insert into Log(procedure_name,time,description, effected_table, number_of_rows)
    values('Hotel.Fill_Country', getdate(), 'truncate table Hotel.Country', 'Hotel.Country', @@ROWCOUNT);

    DECLARE @row_count INT;
    
    INSERT INTO Hotel.Country(country_id,country_name, country_code)
    SELECT country_id, country_name, country_code FROM Source.Hotel.Country;

    SET @row_count = @@ROWCOUNT;
    
    INSERT INTO Log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES('Hotel.Fill_Country', GETDATE(), 'Inserted countries', 'Hotel.Country', @row_count);
    
    INSERT INTO Log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES('Hotel.Fill_Country', GETDATE(), 'end', '', 0);
END
GO
CREATE OR ALTER PROCEDURE Hotel.Fill_Tier
AS
BEGIN
    INSERT INTO Log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES('Hotel.Fill_Tier', GETDATE(), 'start', '', 0);

    TRUNCATE TABLE Hotel.Tier;
    insert into Log(procedure_name,time,description, effected_table, number_of_rows)
    values('Hotel.Fill_Tier', getdate(), 'truncate table Hotel.Tier', 'Hotel.Tier', @@ROWCOUNT);

    DECLARE @row_count INT;
    
    INSERT INTO Hotel.tier(tier_id,type, points_to_reach, discount_for_service, discount_for_stay)
    SELECT tier_id,type, points_to_reach, discount_for_service, discount_for_stay FROM Source.Hotel.tier;
    
    SET @row_count = @@ROWCOUNT;
    
    INSERT INTO Log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES('Hotel.Fill_Tier', GETDATE(), 'Inserted tiers', 'Hotel.tier', @row_count);
    
    INSERT INTO Log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES('Hotel.Fill_Tier', GETDATE(), 'end', '', 0);
END
GO

CREATE OR ALTER PROCEDURE Hotel.Fill_Room_Status
AS
BEGIN
    INSERT INTO Log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES('Hotel.Fill_Room_Status', GETDATE(), 'start', '', 0);

    TRUNCATE TABLE Hotel.room_status;
    insert into Log(procedure_name,time,description, effected_table, number_of_rows)
    values('Hotel.Fill_Room_Status', getdate(), 'truncate table Hotel.room_status', 'Hotel.room_status', @@ROWCOUNT);

    DECLARE @row_count INT;
    
    INSERT INTO Hotel.room_status(status_id,status_name, description)
    SELECT status_id, status_name, description FROM Source.Hotel.room_status;

    SET @row_count = @@ROWCOUNT;
    
    INSERT INTO Log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES('Hotel.Fill_Room_Status', GETDATE(), 'Inserted room statuses', 'Hotel.room_status', @row_count);
    
    INSERT INTO Log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES('Hotel.Fill_Room_Status', GETDATE(), 'end', '', 0);
END

GO
CREATE OR ALTER PROCEDURE Hotel.Fill_Room
AS
BEGIN
    INSERT INTO Log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES('Hotel.Fill_Room', GETDATE(), 'start', '', 0);
    
    
    TRUNCATE TABLE Hotel.room;
    insert into Log(procedure_name,time,description, effected_table, number_of_rows)
    values('Hotel.Fill_Room', getdate(), 'truncate table Hotel.room', 'Hotel.room', @@ROWCOUNT);

    DECLARE @row_count INT;
    
    INSERT INTO Hotel.room(capacity, floor, room_number, number_of_single_bed, number_of_double_bed, cost_per_day, status_id)
    SELECT capacity, floor, room_number, number_of_single_bed, number_of_double_bed, cost_per_day, status_id 
    FROM Source.Hotel.room;
    
    SET @row_count = @@ROWCOUNT;
    
    INSERT INTO Log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES('Hotel.Fill_Room', GETDATE(), 'Inserted rooms', 'Hotel.room', @row_count);
    
    INSERT INTO Log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES('Hotel.Fill_Room', GETDATE(), 'end', '', 0);
END

GO

CREATE OR ALTER PROCEDURE Hotel.Fill_Guest
AS
BEGIN
    INSERT INTO Log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES('Hotel.Fill_Guest', GETDATE(), 'start', '', 0);
    
    
    TRUNCATE TABLE Hotel.Guest;
    insert into Log(procedure_name,time,description, effected_table, number_of_rows)
    values('Hotel.Fill_Guest', getdate(), 'truncate table Hotel.Guest', 'Hotel.Guest', @@ROWCOUNT);

    DECLARE @row_count INT;

    INSERT INTO Hotel.Guest(guest_id, tier_id, country_id, national_code, first_name, last_name, phone_number, email, address, points)
    SELECT guest_id, tier_id, country_id, national_code, first_name, last_name, phone_number, email, address, points
    FROM Source.Hotel.Guest;
    
    SET @row_count = @@ROWCOUNT;
    
    INSERT INTO Log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES('Hotel.Fill_Guest', GETDATE(), 'Inserted guests', 'Hotel.Guest', @row_count);
    
    INSERT INTO Log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES('Hotel.Fill_Guest', GETDATE(), 'end', '', 0);
END


GO
CREATE OR ALTER PROCEDURE Hotel.Fill_Category
AS
BEGIN
    INSERT INTO Log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES('Hotel.Fill_Category', GETDATE(), 'start', '', 0);
    
    
    TRUNCATE TABLE Hotel.category;
    insert into Log(procedure_name,time,description, effected_table, number_of_rows)
    values('Hotel.Fill_Category', getdate(), 'truncate table Hotel.category', 'Hotel.category', @@ROWCOUNT);

    DECLARE @row_count INT;
    
    INSERT INTO Hotel.category(category_name, description)
    SELECT category_name, description FROM Source.Hotel.category;
    
    SET @row_count = @@ROWCOUNT;
    
    INSERT INTO Log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES('Hotel.Fill_Category', GETDATE(), 'Inserted categories', 'Hotel.category', @row_count);
    
    INSERT INTO Log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES('Hotel.Fill_Category', GETDATE(), 'end', '', 0);
END
GO
CREATE OR ALTER PROCEDURE Hotel.Fill_Employee
AS
BEGIN
    INSERT INTO Log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES('Hotel.Fill_Employee', GETDATE(), 'start', '', 0);
    
    
    TRUNCATE TABLE Hotel.employee;
    insert into Log(procedure_name,time,description, effected_table, number_of_rows)
    values('Hotel.Fill_Employee', getdate(), 'truncate table Hotel.employee', 'Hotel.employee', @@ROWCOUNT);

    DECLARE @row_count INT;
    
    INSERT INTO Hotel.Employee( employee_id,national_code, birthday, role_id, first_name, last_name, phone_number, address, salary, hire_date, is_active, gender)
    SELECT employee_id,national_code, birthday, role_id, first_name, last_name, phone_number, address, salary, hire_date, is_active, CASE when is_male = 1 then  'male' else 'female' end
    FROM Source.Hotel.Employee;
    
    SET @row_count = @@ROWCOUNT;
    
    INSERT INTO Log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES('Hotel.Fill_Employee', GETDATE(), 'Inserted employees', 'Hotel.Employee', @row_count);
    
    INSERT INTO Log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES('Hotel.Fill_Employee', GETDATE(), 'end', '', 0);
END



GO
CREATE OR ALTER PROCEDURE Hotel.Fill_Item
AS
BEGIN
    INSERT INTO Log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES('Hotel.Fill_Item', GETDATE(), 'start', '', 0);
    
    
    TRUNCATE TABLE Hotel.item;
    insert into Log(procedure_name,time,description, effected_table, number_of_rows)
    values('Hotel.Fill_Item', getdate(), 'truncate table Hotel.item', 'Hotel.item', @@ROWCOUNT);

    DECLARE @row_count INT;
    
    INSERT INTO Hotel.item(item_id,item_name, category_id, cost, charge, duration_to_prepare, description)
    SELECT item_id,item_name, category_id, cost, charge, duration_to_prepare, description
    FROM Source.Hotel.item;
    
    SET @row_count = @@ROWCOUNT;
    
    INSERT INTO Log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES('Hotel.Fill_Item', GETDATE(), 'Inserted items', 'Hotel.item', @row_count);
    
    INSERT INTO Log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES('Hotel.Fill_Item', GETDATE(), 'end', '', 0);
END


GO

CREATE OR ALTER PROCEDURE Hotel.Fill_service
AS
BEGIN
    INSERT INTO Log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES('Hotel.Fill_service', GETDATE(), 'start', '', 0);
    
    DECLARE @row_count INT;
    declare @current_date date;
    declare @end_date date = cast(getdate() as date);
    select @current_date= dateadd(day, 1, cast(max(time) as date)) from Hotel.service;

    if @current_date is null
        select @current_date=cast(min(time) as date) from source.Hotel.service;

    while @current_date < @end_date
    begin
        insert into hotel.service(service_id, employee_id, room_id, duration_to_complete, time, type, description)
        select service_id, employee_id, room_id, duration_to_complete, time, type, description
        from Source.Hotel.service
        where time >= @current_date and time < DATEADD(day, 1, @current_date);
        
        insert into log(procedure_name, time, description, effected_table, number_of_rows)
        values('Hotel.Fill_service', GETDATE(), 'Inserted services for ' + CONVERT(VARCHAR, @current_date, 120), 'Hotel.service', @@ROWCOUNT);
        
        set @current_date = dateadd(day, 1, @current_date);

    end

    INSERT INTO Log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES('Hotel.Fill_service', GETDATE(), 'end', '', 0);
END
GO

CREATE OR ALTER PROCEDURE Hotel.Fill_service_detail
AS
BEGIN
    INSERT INTO Log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES('Hotel.Fill_service_detail', GETDATE(), 'start', '', 0);
    
    DECLARE @row_count INT;
    declare @current_date date;
    declare @end_date date = cast(getdate() as date);
    select @current_date= dateadd(day, 1, cast(max(time) as date)) from Hotel.service_detail det  JOIN Hotel.service serv ON serv.service_id = det.service_id;

    if @current_date is null
        select @current_date=cast(min(time) as date) from source.Hotel.service;

    while @current_date < @end_date
    begin
        insert into hotel.service_detail(service_detail_id, service_id, item_id, quantity)
        select service_detail_id, serv.service_id, item_id, quantity
        from Source.Hotel.service_detail det JOIN source.hotel.service  serv ON serv.service_id = det.service_id
        where time >= @current_date and time < DATEADD(day, 1, @current_date);
        
        insert into log(procedure_name, time, description, effected_table, number_of_rows)
        values('Hotel.Fill_service_detail', @current_date, 'Inserted services for ' + CONVERT(VARCHAR, @current_date, 120), 'Hotel.service_detail', @@ROWCOUNT);
        
        set @current_date = dateadd(day, 1, @current_date);

    end

    INSERT INTO Log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES('Hotel.Fill_service_detail', GETDATE(), 'end', '', 0);
END
GO
CREATE OR ALTER PROCEDURE Hotel.Fill_booking
AS
BEGIN

    INSERT INTO Log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES('Hotel.Fill_booking', GETDATE(), 'start', '', 0);

    DECLARE @row_count INT;
    declare @current_date date;
    declare @end_date date = cast(getdate() as date);
    select @current_date= dateadd(day, 1, cast(max(checkout_time) as date)) from Hotel.booking;

    if @current_date is null
        select @current_date=cast(min(checkout_time) as date) from source.Hotel.booking;

    while @current_date < @end_date
    begin
        insert into hotel.booking(booking_id, checkin_time, checkout_time, primary_guest_id, room_id)
        select booking_id, checkin_time, checkout_time, primary_guest_id, room_id
        from Source.Hotel.booking
        where checkin_time is NULL or (checkin_time >= @current_date and checkin_time < DATEADD(day, 1, @current_date));

        insert into log(procedure_name, time, description, effected_table, number_of_rows)
        values('Hotel.Fill_booking', @current_date, 'Inserted bookings for ' + CONVERT(VARCHAR, @current_date, 120), 'Hotel.booking', @@ROWCOUNT);

        set @current_date = dateadd(day, 1, @current_date);

    end

    INSERT INTO Log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES('Hotel.Fill_booking', GETDATE(), 'end', '', 0);

end;
exec hotel.Fill_booking
exec hotel.Fill_Country;

select * from hotel.country;

exec hotel.Fill_Item
select * from hotel.item