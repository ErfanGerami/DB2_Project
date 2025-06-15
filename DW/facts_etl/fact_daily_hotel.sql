create or alter procedure hotel.fill_fact_daily_hotel_first_load
as
BEGIN

    insert into log (procedure_name, time, description, effected_table, number_of_rows)
    values ('fill_fact_daily_hotel_first_load', getdate(), 'start', 'fact_daily_hotel', 0);
    truncate table hotel.fact_daily_hotel;
    insert into [Log] (procedure_name, time, description, effected_table, number_of_rows)
    VALUES ('fill_fact_daily_hotel_first_load', GETDATE(), 'truncate table hotel.fact_daily_hotel', 'hotel.fact_daily_hotel', @@ROWCOUNT);

    declare @current_date date = (select min(cast(checkout_time as date)) from sa.hotel.booking);
    declare @end_date date = getdate();
    
    while @current_date < @end_date
    begin

        insert into hotel.fact_daily_hotel (room_id,room_key, room_status_id, date_id, total_service_count, total_service_cost, total_service_charge, total_service_discount)
        select 
            r.room_id,
            fs.room_key,
            r.status_id,
            @current_date as date_id,
            count(fs.service_id) as total_service_count,
            ISNULL(sum(fs.cost), 0) as total_service_cost,
            ISNULL(sum(fs.charge), 0) as total_service_charge,
            ISNULL(sum(fs.discount_amount), 0) as total_service_discount
        from sa.hotel.room r 
        left join hotel.fact_transactional_service fs on fs.room_id = r.room_id and fs.date_id >= @current_date and fs.date_id < dateadd(day, 1, @current_date)
        LEFT JOIN hotel.dim_room dr on dr.room_id=r.room_id and current_flag=1
        group by 
            r.room_id,
            r.status_id,
            fs.room_key;
        insert into log (procedure_name, time, description, effected_table, number_of_rows)
        values ('fill_fact_daily_hotel_first_load', getdate(), 'inserted data for date: ' + cast(@current_date as varchar(10)), 'fact_daily_hotel', @@ROWCOUNT);

        set @current_date = dateadd(day, 1, @current_date);
    end

    insert into log (procedure_name, time, description, effected_table, number_of_rows)
    values ('fill_fact_daily_hotel_first_load', getdate(), 'end', 'fact_daily_hotel', 0);

END;
GO
create or alter procedure hotel.fill_fact_daily_hotel
as
BEGIN

    insert into log (procedure_name, time, description, effected_table, number_of_rows)
    values ('fill_fact_daily_hotel', getdate(), 'start', 'fact_daily_hotel', 0);

    declare @current_date date = (select max(cast(date_id as date)) from hotel.fact_daily_hotel);
    set @current_date = dateadd(day, 1, @current_date);
    if @current_date is null
    begin
        set @current_date = (select min(cast(checkin_time as date)) from sa.hotel.booking);
    end
    declare @end_date date = getdate();
    
    while @current_date < @end_date
    begin

        insert into hotel.fact_daily_hotel (room_id,room_key, room_status_id, date_id, total_service_count, total_service_cost, total_service_charge, total_service_discount)
        select 
            r.room_id,
            fs.room_key,
            r.status_id,
            @current_date as date_id,
            count(fs.service_id) as total_service_count,
            ISNULL(sum(fs.cost), 0) as total_service_cost,
            ISNULL(sum(fs.charge), 0) as total_service_charge,
            ISNULL(sum(fs.discount_amount), 0) as total_service_discount
        from sa.hotel.room r 
        left join hotel.fact_transactional_service fs on fs.room_id = r.room_id and   fs.room_id = r.room_id and fs.date_id >= @current_date and fs.date_id < dateadd(day, 1, @current_date)
        LEFT JOIN hotel.dim_room dr on dr.room_id=r.room_id and current_flag=1

        group by 
            r.room_id,
            r.status_id,
            fs.room_key;
        insert into log (procedure_name, time, description, effected_table, number_of_rows)
        values ('fill_fact_daily_hotel', getdate(), 'inserted data for date: ' + cast(@current_date as varchar(10)), 'fact_daily_hotel', @@ROWCOUNT);

        set @current_date = dateadd(day, 1, @current_date);
    end

    insert into log (procedure_name, time, description, effected_table, number_of_rows)
    values ('fill_fact_daily_hotel', getdate(), 'end', 'fact_daily_hotel', 0);

END;
