create or alter procedure hotel.fill_fact_transactional_booking_first_load AS
BEGIN

    insert into log (procedure_name, time, description, effected_table, number_of_rows)
    values ('fill_fact_transactional_booking_first_load', getdate(), 'start', 'fact_transactional_booking', 0);
    
    truncate table hotel.fact_transactional_booking;
    insert into [Log] (procedure_name, time, description, effected_table, number_of_rows)
    VALUES ('fill_fact_transactional_booking_first_load', GETDATE(), 'truncate table hotel.fact_transactional_booking', 'hotel.fact_transactional_booking', @@ROWCOUNT);

    declare @current_date date = (select min(cast(checkin_time as date)) from sa.hotel.booking);
    declare @end_date date = getdate();
    while @current_date < @end_date
    begin

        insert into hotel.fact_transactional_booking (guest_id, room_id,room_key, tier_id, checkin_time, checkout_time, total_service_cost, total_service_charge, total_service_item_count, total_room_charge, total_charge, duration_time, total_service_discount, total_room_discount)
        select 
            b.primary_guest_id as guest_id,
            b.room_id,
            fs.room_key,
            g.tier_id,
            b.checkin_time,
            b.checkout_time,
            ISNULL(sum(fs.cost),0) as total_service_cost,
            ISNULL(sum(fs.charge),0) as total_service_charge,
            ISNULL(sum(fs.item_count),0) as total_service_item_count,
            b.total_charge as total_room_charge,
            ISNULL(sum(fs.charge),0) + b.total_charge as total_charge,
            datediff(minute, b.checkin_time, b.checkout_time) as duration_time,
            ISNULL(sum(fs.discount_amount),0) as total_service_discount,
            ISNULL(sum(fs.discount_amount),0) + b.total_discount as total_room_discount
        from sa.hotel.booking b
        left join hotel.fact_transactional_service fs on fs.booking_id = b.booking_id 
        left join sa.hotel.room r on r.room_id = b.room_id
        left join sa.hotel.guest g on g.guest_id = b.primary_guest_id
     ---   LEFT JOIN hotel.dim_room dr on dr.room_id=r.room_id and current_flag=1

        where checkout_time >= @current_date and checkout_time < dateadd(day, 1, @current_date)
        group by 
            b.primary_guest_id,
            b.room_id,
            g.tier_id,
            b.checkin_time,
            b.checkout_time,
            b.booking_id,
            b.total_charge,
            b.total_discount,
            fs.room_key
            ;


        insert into log (procedure_name, time, description, effected_table, number_of_rows)
        values ('fill_fact_transactional_booking_first_load', getdate(), 'inserted data for date: ' + cast(@current_date as varchar(10)), 'fact_transactional_booking', @@ROWCOUNT);

        set @current_date = dateadd(day, 1, @current_date);
    end

    insert into log (procedure_name, time, description, effected_table, number_of_rows)
    values ('fill_fact_transactional_booking_first_load', getdate(), 'end', 'fact_transactional_booking', 0);

end;
GO


create or alter procedure hotel.fill_fact_transactional_booking AS
BEGIN

    insert into log (procedure_name, time, description, effected_table, number_of_rows)
    values ('fill_fact_transactional_booking', getdate(), 'start', 'fact_transactional_booking', 0);
    
    declare @current_date date = (select max(checkout_time) from hotel.fact_transactional_booking);
    set @current_date = dateadd(day, 1, @current_date);
    if @current_date is null
    begin
        set @current_date = (select min(cast(checkout_time as date)) from sa.hotel.booking);
    end
    declare @end_date date = getdate();
    while @current_date < @end_date
    begin

        insert into hotel.fact_transactional_booking (guest_id, room_id,room_key, tier_id, checkin_time, checkout_time, total_service_cost, total_service_charge, total_service_item_count, total_room_charge, total_charge, duration_time, total_service_discount, total_room_discount)
        select 
            b.primary_guest_id as guest_id,
            b.room_id,
            fs.room_key,
            g.tier_id,
            b.checkin_time,
            b.checkout_time,
            ISNULL(sum(fs.cost),0) as total_service_cost,
            ISNULL(sum(fs.charge),0) as total_service_charge,
            ISNULL(sum(fs.item_count),0) as total_service_item_count,
            b.total_charge as total_room_charge,
            ISNULL(sum(fs.charge),0) + b.total_charge as total_charge,
            datediff(minute, b.checkin_time, b.checkout_time) as duration_time,
            ISNULL(sum(fs.discount_amount),0) as total_service_discount,
            ISNULL(sum(fs.discount_amount),0) + b.total_discount as total_room_discount
        from sa.hotel.booking b
        left join hotel.fact_transactional_service fs on fs.booking_id = b.booking_id 
        left join sa.hotel.room r on r.room_id = b.room_id
        left join sa.hotel.guest g on g.guest_id = b.primary_guest_id
      ---  LEFT JOIN hotel.dim_room dr on dr.room_id=r.room_id and current_flag=1

        where checkout_time >= @current_date and checkout_time < dateadd(day, 1, @current_date)
        group by 
            b.primary_guest_id,
            b.room_id,
            g.tier_id,
            b.checkin_time,
            b.checkout_time,
            b.booking_id,
            b.total_charge,
            b.total_discount,
            fs.room_key

            ;


        insert into log (procedure_name, time, description, effected_table, number_of_rows)
        values ('fill_fact_transactional_booking', getdate(), 'inserted data for date: ' + cast(@current_date as varchar(10)), 'fact_transactional_booking', @@ROWCOUNT);

        set @current_date = dateadd(day, 1, @current_date);
    end

    insert into log (procedure_name, time, description, effected_table, number_of_rows)
    values ('fill_fact_transactional_booking', getdate(), 'end', 'fact_transactional_booking', 0);

end;

