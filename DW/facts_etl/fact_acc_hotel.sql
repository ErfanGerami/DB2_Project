CREATE OR ALTER PROCEDURE hotel.fill_fact_acc_hotel
AS
BEGIN
    
    INSERT INTO log (procedure_name, time, description, effected_table, number_of_rows)
    VALUES ('fill_fact_acc_hotel', GETDATE(), 'start', 'fact_acc_hotel', 0);

    DECLARE @end_date DATE = GETDATE();
    DECLARE @current_date DATE = (SELECT MAX(CAST(time AS DATE)) FROM LOG WHERE procedure_name = 'fill_fact_acc_hotel' or procedure_name = 'fill_fact_acc_hotel_first_load');

    WHILE @current_date < @end_date
    BEGIN
        if(not EXISTS(select * from hotel.fact_acc_hotel ))
        begin
            WITH temp_acc AS (
                SELECT 
                    r.room_id,
                    r.status_id AS room_status_id,
                    ISNULL(SUM(fs.cost), 0) AS running_service_cost,
                    ISNULL(SUM(fs.charge), 0) AS running_service_charge,
                    COUNT(fs.service_id) AS running_service_count,
                    ISNULL(SUM(fs.discount_amount), 0) AS running_service_discount
                    
                FROM sa.hotel.room r
                
                LEFT JOIN hotel.fact_transactional_service fs 
                    ON fs.room_id = r.room_id
               WHERE fs.date_id >= @current_date AND fs.date_id < DATEADD(DAY, 1, @current_date)
                GROUP BY 
                    r.room_id,
                    r.status_id
            ),stays AS (
                SELECT 
                    b.room_id,
                    COUNT(b.booking_id) AS running_number_of_bookings,
                    SUM(DATEDIFF(MINUTE, b.checkin_time, b.checkout_time)) AS total_stay_time,
                    ISNULL(SUM(b.total_discount), 0) AS running_room_discount,
                    ISNULL(SUM(b.total_charge), 0) AS running_room_charge
                FROM sa.hotel.booking b
               WHERE b.checkout_time >= @current_date AND b.checkout_time < DATEADD(DAY, 1, @current_date)
                GROUP BY b.room_id
            )
            INSERT INTO hotel.fact_acc_hotel (
                room_id,
                room_key,
                room_status_id,
                running_service_cost,
                running_service_charge,
                running_service_count,
                running_service_discount,
                running_room_discount,
                running_room_charge,
                avg_duration,
                running_number_of_bookings
            ) select 
                r.room_id,
                dr.room_key,
                r.status_id,
                ISNULL(temp.running_service_cost, 0),
                ISNULL(temp.running_service_charge, 0),
                ISNULL(temp.running_service_count, 0),
                ISNULL(temp.running_service_discount, 0),
                ISNULL(s.running_room_discount, 0),
                ISNULL(s.running_room_charge, 0),
                CASE ISNULL(s.running_number_of_bookings, 0) 
                    WHEN 0 THEN 0
                    ELSE ISNULL(s.total_stay_time, 0) / ISNULL(s.running_number_of_bookings,0)
                END AS avg_duration,
                ISNULL(s.running_number_of_bookings, 0)
            from sa.hotel.room r LEFT JOIN
                temp_acc temp ON r.room_id = temp.room_id
            LEFT JOIN stays s 
                ON r.room_id = s.room_id
            LEFT JOIN hotel.dim_room  dr ON r.room_id=dr.room_id and dr.current_flag=1;

            insert into [Log] (procedure_name, time, description, effected_table, number_of_rows)
            values ('fill_fact_acc_hotel', GETDATE(), 'inserted data for date: ' + CAST(@current_date AS VARCHAR(10)), 'fact_acc_hotel', @@ROWCOUNT);
            

        END
        else
        begin
            WITH temp_acc AS (

                SELECT 
                    r.room_id,
                    r.status_id AS room_status_id,
                    ISNULL(SUM(fs.cost), 0) AS running_service_cost,
                    ISNULL(SUM(fs.charge), 0) AS running_service_charge,
                    COUNT(fs.service_id) AS running_service_count,
                    ISNULL(SUM(fs.discount_amount), 0) AS running_service_discount
                    
                FROM sa.hotel.room r
                
                LEFT JOIN hotel.fact_transactional_service fs 
                    ON fs.room_id = r.room_id
                WHERE fs.date_id >= @current_date AND fs.date_id < DATEADD(DAY, 1, @current_date)
                GROUP BY 
                    r.room_id,
                    r.status_id
            ),stays AS (
                SELECT 
                    b.room_id,
                    COUNT(b.booking_id) AS running_number_of_bookings,
                    SUM(DATEDIFF(MINUTE, b.checkin_time, b.checkout_time)) AS total_stay_time,
                    ISNULL(SUM(b.total_discount), 0) AS running_room_discount,
                    ISNULL(SUM(b.total_charge), 0) AS running_room_charge
                FROM sa.hotel.booking b
                WHERE b.checkout_time >= @current_date AND b.checkout_time < DATEADD(DAY, 1, @current_date)
                GROUP BY b.room_id
            )
            UPDATE fact
            SET 
                fact.running_service_cost = fact.running_service_cost+ISNULL(temp.running_service_cost,0),
                fact.running_service_charge = fact.running_service_charge+ISNULL(temp.running_service_charge,0),
                fact.running_service_count = fact.running_service_count+ISNULL(temp.running_service_count,0),
                fact.running_service_discount = fact.running_service_discount+ISNULL(temp.running_service_discount,0),
                fact.running_room_discount = fact.running_room_discount+ISNULL(s.running_room_discount,0),
                fact.running_room_charge = fact.running_room_charge+ISNULL(s.running_room_charge,0),
                fact.avg_duration = CASE 
                    WHEN fact.running_number_of_bookings + ISNULL(s.running_number_of_bookings, 0) > 0 THEN
                        (fact.avg_duration * fact.running_number_of_bookings + ISNULL(s.total_stay_time, 0)) 
                        / (fact.running_number_of_bookings + ISNULL(s.running_number_of_bookings, 0))
                    ELSE 0
                END,
                fact.running_number_of_bookings = fact.running_number_of_bookings + ISNULL(s.running_number_of_bookings, 0),
                room_key=dr.room_key,
                room_status_id=dr.status_id

            FROM hotel.fact_acc_hotel fact
            LEFT JOIN temp_acc temp 
                ON fact.room_id = temp.room_id 
            LEFT JOIN stays s 
                ON fact.room_id = s.room_id
            LEFT JOIN hotel.dim_room dr on dr.room_id=fact.room_id and dr.current_flag=1;
        
            insert into [Log] (procedure_name, time, description, effected_table, number_of_rows)
            values ('fill_fact_acc_hotel', GETDATE(), 'updated data for date: ' + CAST(@current_date AS VARCHAR(10)), 'fact_acc_hotel', @@ROWCOUNT);
        END;

        SET @current_date = DATEADD(DAY, 1, @current_date);


    END;

    INSERT INTO log (procedure_name, time, description, effected_table, number_of_rows)
    VALUES ('fill_fact_acc_hotel', GETDATE(), 'end', 'fact_acc_hotel', @@ROWCOUNT);
END;

GO
CREATE OR ALTER PROCEDURE hotel.fill_fact_acc_hotel_first_load
AS
BEGIN
    
    INSERT INTO log (procedure_name, time, description, effected_table, number_of_rows)
    VALUES ('fill_fact_acc_hotel_first_load', GETDATE(), 'start', 'fact_acc_hotel', 0);

    truncate table hotel.fact_acc_hotel;
    insert into [Log] (procedure_name, time, description, effected_table, number_of_rows)
    VALUES ('fill_fact_acc_hotel_first_load', GETDATE(), 'truncate table hotel.fact_acc_hotel', 'hotel.fact_acc_hotel', @@ROWCOUNT);


    DECLARE @end_date DATE = GETDATE();

    DECLARE @current_date DATE = (SELECT MIN(CAST(date_id AS DATE)) FROM hotel.fact_daily_hotel);
    
    if(@current_date is null)
    begin
        return;
    end

    WHILE @current_date < @end_date
    BEGIN
        
        if(not EXISTS(select * from hotel.fact_acc_hotel ))
        begin
    
            WITH temp_acc AS (
                SELECT 
                    r.room_id,
                    r.status_id AS room_status_id,
                    ISNULL(SUM(fs.cost), 0) AS running_service_cost,
                    ISNULL(SUM(fs.charge), 0) AS running_service_charge,
                    COUNT(fs.service_id) AS running_service_count,
                    ISNULL(SUM(fs.discount_amount), 0) AS running_service_discount
                    
                FROM sa.hotel.room r
                
                LEFT JOIN hotel.fact_transactional_service fs 
                    ON fs.room_id = r.room_id
               WHERE fs.date_id >= @current_date AND fs.date_id < DATEADD(DAY, 1, @current_date)
                GROUP BY 
                    r.room_id,
                    r.status_id
            ),stays AS (
                SELECT 
                    b.room_id,
                    COUNT(b.booking_id) AS running_number_of_bookings,
                    SUM(DATEDIFF(MINUTE, b.checkin_time, b.checkout_time)) AS total_stay_time,
                    ISNULL(SUM(b.total_discount), 0) AS running_room_discount,
                    ISNULL(SUM(b.total_charge), 0) AS running_room_charge
                FROM sa.hotel.booking b
               WHERE b.checkout_time >= @current_date AND b.checkout_time < DATEADD(DAY, 1, @current_date)
                GROUP BY b.room_id
            )
            INSERT INTO hotel.fact_acc_hotel (
                room_id,
                room_key,
                room_status_id,
                running_service_cost,
                running_service_charge,
                running_service_count,
                running_service_discount,
                running_room_discount,
                running_room_charge,
                avg_duration,
                running_number_of_bookings
            ) select 
                r.room_id,
                dr.room_key,
                dr.status_id,
                ISNULL(temp.running_service_cost, 0),
                ISNULL(temp.running_service_charge, 0),
                ISNULL(temp.running_service_count, 0),
                ISNULL(temp.running_service_discount, 0),
                ISNULL(s.running_room_discount, 0),
                ISNULL(s.running_room_charge, 0),
                CASE ISNULL(s.running_number_of_bookings, 0) 
                    WHEN 0 THEN 0
                    ELSE ISNULL(s.total_stay_time, 0) / ISNULL(s.running_number_of_bookings,0)
                END AS avg_duration,
                ISNULL(s.running_number_of_bookings, 0)
            from sa.hotel.room r LEFT JOIN
                temp_acc temp ON r.room_id = temp.room_id
            LEFT JOIN stays s 
                ON r.room_id = s.room_id
            LEFT JOIN hotel.dim_room dr on dr.room_id=r.room_id and dr.current_flag=1
            ;
            insert into [Log] (procedure_name, time, description, effected_table, number_of_rows)
            values ('fill_fact_acc_hotel_first_load', GETDATE(), 'inserted data for date: ' + CAST(@current_date AS VARCHAR(10)), 'fact_acc_hotel', @@ROWCOUNT);


        END
        else
        begin
            WITH temp_acc AS (
                SELECT 
                    r.room_id,
                    r.status_id AS room_status_id,
                    ISNULL(SUM(fs.cost), 0) AS running_service_cost,
                    ISNULL(SUM(fs.charge), 0) AS running_service_charge,
                    COUNT(fs.service_id) AS running_service_count,
                    ISNULL(SUM(fs.discount_amount), 0) AS running_service_discount
                    
                FROM sa.hotel.room r
                
                LEFT JOIN hotel.fact_transactional_service fs 
                    ON fs.room_id = r.room_id
                WHERE fs.date_id >= @current_date AND fs.date_id < DATEADD(DAY, 1, @current_date)
                GROUP BY 
                    r.room_id,
                    r.status_id
            ),stays AS (
                SELECT 
                    b.room_id,
                    COUNT(b.booking_id) AS running_number_of_bookings,
                    SUM(DATEDIFF(MINUTE, b.checkin_time, b.checkout_time)) AS total_stay_time,
                    ISNULL(SUM(b.total_discount), 0) AS running_room_discount,
                    ISNULL(SUM(b.total_charge), 0) AS running_room_charge
                FROM sa.hotel.booking b
                WHERE b.checkout_time >= @current_date AND b.checkout_time < DATEADD(DAY, 1, @current_date)
                GROUP BY b.room_id
            )
            UPDATE fact
            SET 
                fact.running_service_cost = fact.running_service_cost+ISNULL(temp.running_service_cost,0),
                fact.running_service_charge = fact.running_service_charge+ISNULL(temp.running_service_charge,0),
                fact.running_service_count = fact.running_service_count+ISNULL(temp.running_service_count,0),
                fact.running_service_discount = fact.running_service_discount+ISNULL(temp.running_service_discount,0),
                fact.running_room_discount = fact.running_room_discount+ISNULL(s.running_room_discount,0),
                fact.running_room_charge = fact.running_room_charge+ISNULL(s.running_room_charge,0),
                fact.avg_duration = CASE 
                    WHEN fact.running_number_of_bookings + ISNULL(s.running_number_of_bookings, 0) > 0 THEN
                        (fact.avg_duration * fact.running_number_of_bookings + ISNULL(s.total_stay_time, 0)) 
                        / (fact.running_number_of_bookings + ISNULL(s.running_number_of_bookings, 0))
                    ELSE 0
                END,
                fact.running_number_of_bookings = fact.running_number_of_bookings + ISNULL(s.running_number_of_bookings, 0),
                room_key=dr.room_key,
                room_status_id=dr.status_id
            FROM hotel.fact_acc_hotel fact
            LEFT JOIN temp_acc temp 
                ON fact.room_id = temp.room_id
            LEFT JOIN stays s 
                ON fact.room_id = s.room_id
            LEFT JOIN hotel.dim_room dr ON dr.room_id=fact.room_id and dr.current_flag=1;
                ;
        
            insert into [Log] (procedure_name, time, description, effected_table, number_of_rows)
            values ('fill_fact_acc_hotel', GETDATE(), 'updated data for date: ' + CAST(@current_date AS VARCHAR(10)), 'fact_acc_hotel', @@ROWCOUNT);
        END;
        set @current_date = DATEADD(DAY, 1, @current_date);

    END;

    INSERT INTO log (procedure_name, time, description, effected_table, number_of_rows)
    VALUES ('fill_fact_acc_hotel', GETDATE(), 'end', 'fact_acc_hotel', @@ROWCOUNT);
END;
select * from log
order by time desc;