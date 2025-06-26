
create or alter procedure hotel.main_proc_first_load AS  
BEGIN

    insert into log (procedure_name, time, description, effected_table, number_of_rows)
    values ('main_proc_first_load', getdate(), 'start', 'main_proc_first_load', 0);

    -- -- Reset identities in Restaurant schema
    -- DBCC CHECKIDENT ('Restaurant.dim_food', RESEED, 0);

    DBCC CHECKIDENT ('hotel.dim_room', RESEED, 0);

	DECLARE @end_date DATE=dateadd(day,-1,getdate());
	DECLARE @start_date DATE;

    exec Hotel.fill_dim_tier_first_load;

    exec Hotel.fill_dim_room_first_load;
    exec hotel.fill_dim_item_first_load;
    exec hotel.fill_dim_employee_first_load;
    exec hotel.fill_dim_room_status_first_load;
    exec hotel.fill_dim_guest_first_load;
    


	--transactional service--------------------------------
	
    set @start_date = (select min(cast(time as date)) from Sa.Hotel.service);

    exec hotel.fill_fact_transactional_service_first_load @start_date=@start_date,@end_date=@end_date;






	---transactional booking---------------------------
	set @start_date  = (select min(cast(checkin_time as date)) from sa.hotel.booking);
    exec hotel.fill_fact_transactional_booking_first_load @start_date=@start_date,@end_date=@end_date;
    



	--daily-----------------------------------
	set @start_date  = (select min(cast(checkout_time as date)) from sa.hotel.booking);
    exec hotel.fill_fact_daily_hotel_first_load @start_date=@start_date,@end_date=@end_date;;


	--acc---------------------------------
    set @start_date  = (SELECT MIN(CAST(date_id AS DATE)) FROM hotel.fact_daily_hotel);
    
    if(@start_date is null)
    begin
        return;
    end

    exec hotel.fill_fact_acc_hotel_first_load @start_date=@start_date,@end_date=@end_date;

    insert into log (procedure_name, time, description, effected_table, number_of_rows)
    values ('main_proc_first_load', getdate(), 'end', 'main_proc_first_load', 0);

END;
GO
create or alter procedure hotel.main_proc AS  
BEGIN

    insert into log (procedure_name, time, description, effected_table, number_of_rows)
    values ('main_proc', getdate(), 'start', 'main_proc', 0);

	DECLARE @end_date DATE=dateadd(day,-1,getdate());
	DECLARE @start_date DATE;    



    exec Hotel.fill_dim_tier;
    exec Hotel.fill_dim_room;
    exec hotel.fill_dim_item;
    exec hotel.fill_dim_employee;
    exec hotel.fill_dim_room_status;
    exec hotel.fill_dim_guest;





	--transactional service--------------------------------

	
    set @start_date  = (select max(date_id) from Hotel.fact_transactional_service);
    set @start_date = dateadd(day, 1, @start_date);
    if(@start_date is null)
    begin
        set @start_date = (select min(cast(time as date)) from Sa.Hotel.service);
    end

    exec hotel.fill_fact_transactional_service @start_date=@start_date,@end_date=@end_date;



	---transactional booking---------------------------
	set @start_date  = (select max(checkout_time) from hotel.fact_transactional_booking);
    set @start_date = dateadd(day, 1, @start_date);
    if @start_date is null
    begin
        set @start_date = (select min(cast(checkout_time as date)) from sa.hotel.booking);
    end

    exec hotel.fill_fact_transactional_booking @start_date=@start_date,@end_date=@end_date;




	---daily-------------------------------
	
    set @start_date  = (select max(cast(date_id as date)) from hotel.fact_daily_hotel);
    set @start_date = dateadd(day, 1, @start_date);
    if @start_date is null
    begin
        set @start_date = (select min(cast(checkin_time as date)) from sa.hotel.booking);
    end

    exec hotel.fill_fact_daily_hotel @start_date=@start_date,@end_date=@end_date;

	

	---acc-------------------------
    
    set @start_date  = (SELECT MAX(CAST(time AS DATE)) FROM LOG WHERE procedure_name = 'fill_fact_acc_hotel' or procedure_name = 'fill_fact_acc_hotel_first_load');

    exec hotel.fill_fact_acc_hotel @start_date=@start_date,@end_date=@end_date;

    insert into log (procedure_name, time, description, effected_table, number_of_rows)
    values ('main_proc', getdate(), 'end', 'main_proc', 0);

END;



exec hotel.main_proc


select * from hotel.fact_transactional_service
select * from hotel.dim_room
select top 100 *  from hotel.fact_transactional_service order by date_id desc
select max(checkin_time) from hotel.fact_transactional_booking


select count(*) from sa.hotel.service_detail
select count(*) from sa.hotel.booking  

select count( *) from hotel.fact_transactional_booking

select * from hotel.dim_room



select * from hotel.fact_acc_hotel



select * from hotel.dim_room

select * from dw.hotel.fact_acc_hotel 

select * from hotel.dim_room_status