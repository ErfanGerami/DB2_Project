create or alter procedure hotel.fill_fact_transactional_service_first_load
as 
BEGIN

    insert into LOG (procedure_name, time, description, effected_table, number_of_rows)   
    values ('fill_fact_transactional_service_first_load', getdate(), 'start', 'fact_transactional_service', 0);

    truncate table hotel.fact_transactional_service;
    insert into [Log] (procedure_name, time, description, effected_table, number_of_rows)
    VALUES ('fill_fact_transactional_service_first_load', GETDATE(), 'truncate table hotel.fact_transactional_service', 'hotel.fact_transactional_service', @@ROWCOUNT);

    declare @current_date date = (select min(cast(time as date)) from Sa.Hotel.service);

    declare @end_date date = getdate();

    while @current_date<@end_date
    begin

        insert into hotel.fact_transactional_service (room_id,room_key, guest_id, employee_id, date_id, tier_id, service_id, booking_id, charge, cost, item_count, discount_amount)
        select 
            s.room_id,
            dr.room_key,
            b.primary_guest_id as guest_id,
            s.employee_id,
            cast(s.time as date) as date_id,
            g.tier_id,
            s.service_id,
            b.booking_id,
            ISNULL(sum(i.charge * sd.quantity),0) as charge,
            ISNULL(sum(i.cost * sd.quantity), 0) as cost,
            ISNULL(sum(sd.quantity), 0) as item_count,
            ISNULL(sum(i.charge * sd.quantity * t.discount_for_service / 100), 0) as discount_amount
        from sa.hotel.service s
        LEFT JOIN  sa.hotel.service_detail sd on s.service_id = sd.service_id
        LEFT join sa.hotel.item i on sd.item_id = i.item_id
        JOIN sa.hotel.booking b ON s.room_id = b.room_id AND (b.checkout_time >= s.[time] or b.checkout_time is null) and b.checkin_time <= s.time
        JOIN sa.hotel.guest g ON b.primary_guest_id = g.guest_id
        JOIN sa.hotel.tier t ON g.tier_id = t.tier_id
        LEFT JOIN hotel.dim_room dr ON dr.room_id=s.room_id and current_flag=1
        where s.[time] >= @current_date and s.[time] < dateadd(day, 1, @current_date)
        group by 
            s.room_id,
            b.primary_guest_id,
            s.employee_id,
            cast(s.time as date),
            g.tier_id,
            s.service_id,
            b.booking_id,
            sd.service_detail_id,
            dr.room_key
            ;


        
        insert into LOG (procedure_name, time, description, effected_table, number_of_rows)
        values ('fill_fact_transactional_service_first_load', getdate(), 'inserted data for date: ' + cast(@current_date as varchar(10)), 'fact_transactional_service', @@ROWCOUNT);

        set @current_date = dateadd(day, 1, @current_date);
    end

    insert into LOG (procedure_name, time, description, effected_table, number_of_rows)   
    values ('fill_fact_transactional_service_first_load', getdate(), 'end', 'fact_transactional_service', 0);

end;
Go






create or alter procedure hotel.fill_fact_transactional_service
as 
BEGIN

    insert into LOG (procedure_name, time, description, effected_table, number_of_rows)   
    values ('fill_fact_transactional_service', getdate(), 'start', 'fact_transactional_service', 0);

    declare @current_date date = (select max(date_id) from Hotel.fact_transactional_service);
    set @current_date = dateadd(day, 1, @current_date);
    if(@current_date is null)
    begin
        set @current_date = (select min(cast(time as date)) from Sa.Hotel.service);
    end

    declare @end_date date = getdate();

    while @current_date<@end_date
    begin

        insert into hotel.fact_transactional_service (room_id,room_key, guest_id, employee_id, date_id, tier_id, service_id, booking_id, charge, cost, item_count, discount_amount)
        select 
            s.room_id,
            dr.room_key,
            b.primary_guest_id as guest_id,
            s.employee_id,
            cast(s.time as date) as date_id,
            g.tier_id,
            s.service_id,
            b.booking_id,
            ISNULL(sum(i.charge * sd.quantity),0) as charge,
            ISNULL(sum(i.cost * sd.quantity),0) as cost,
            ISNULL(sum(sd.quantity),0) as item_count,
            ISNULL(sum(i.charge * sd.quantity * t.discount_for_service / 100),0) as discount_amount
       from sa.hotel.service s
        LEFT JOIN  sa.hotel.service_detail sd on s.service_id = sd.service_id
        LEFT join sa.hotel.item i on sd.item_id = i.item_id
        JOIN sa.hotel.booking b ON s.room_id = b.room_id AND (b.checkout_time >= s.[time]  or b.checkout_time is null) and b.checkin_time <= s.time
        JOIN sa.hotel.guest g ON b.primary_guest_id = g.guest_id
        JOIN sa.hotel.tier t ON g.tier_id = t.tier_id
        LEFT JOIN hotel.dim_room dr ON dr.room_id=s.room_id and current_flag=1

        where s.[time] >= @current_date and s.[time] < dateadd(day, 1, @current_date)
        group by 
            s.room_id,
            b.primary_guest_id,
            s.employee_id,
            cast(s.time as date),
            g.tier_id,
            s.service_id,
            b.booking_id,
            sd.service_detail_id,
            dr.room_key
            ;


        
        insert into LOG (procedure_name, time, description, effected_table, number_of_rows)
        values ('fill_fact_transactional_service', getdate(), 'inserted data for date: ' + cast(@current_date as varchar(10)), 'fact_transactional_service', @@ROWCOUNT);

        set @current_date = dateadd(day, 1, @current_date);
    end

    insert into LOG (procedure_name, time, description, effected_table, number_of_rows)   
    values ('fill_fact_transactional_service', getdate(), 'end', 'fact_transactional_service', 0);

end;
Go




