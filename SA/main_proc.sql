create or alter procedure main_proc AS
BEGIN
    insert into LOG (procedure_name, time, description, effected_table, number_of_rows)
    values ('main_proc', getdate(), 'start', '', 0);


    EXEC Hotel.Fill_Room_Status;
    EXEC Hotel.Fill_Country;
    EXEC Hotel.Fill_Tier;
    EXEC Hotel.Fill_Category;
    EXEC Hotel.Fill_Employee;
    EXEC Hotel.Fill_Room;
    EXEC Hotel.Fill_Guest;
    EXEC Hotel.Fill_Item;
    EXEC Hotel.Fill_service;
    EXEC Hotel.Fill_Employee;

	declare @current_date date;
	declare @end_date date = dateadd(day,-1,cast(getdate() as date));
    select @current_date= dateadd(day, 1, cast(max(time) as date)) from Hotel.service_detail det  JOIN Hotel.service serv ON serv.service_id = det.service_id;
    
    if @current_date is null
        select @current_date=cast(min(time) as date) from source.Hotel.service;

    PRINT @current_date;
    PRINT @end_date;
    EXEC Hotel.Fill_service_detail @from_date=@current_date, @to_date=@end_date;


	set @end_date = dateadd(day,-1,cast(getdate() as date));
    select @current_date= dateadd(day, 1, cast(max(checkin_time) as date)) from Hotel.booking;

    if @current_date is null
        select @current_date=cast(min(checkin_time) as date) from source.Hotel.booking;


	PRINT @current_date;
    PRINT @end_date;
    EXEC Hotel.Fill_booking @from_date=@current_date, @to_date=@end_date;

    insert into LOG (procedure_name, time, description, effected_table, number_of_rows)
    values ('main_proc', getdate(), 'end', '', 0);

END;





exec main_proc


select * from [Log]

select count(*) from hotel.service s JOIN hotel.service_detail d on s.service_id=d.service_id 
LEFT JOIN dw.hotel.fact_transactional_service f  on f.service_id=s.service_id and f.item_id=d.item_id
where f.item_id is null and day(cast([time] as date)) =17

select count(*) from sa.hotel.service_detail 
select count(*) from hotel.booking


update  source.hotel.room set cost_per_day=11;


select count(*)  from Restaurant.[order_details]
select * from Restaurant.role
select count(*) from dw.Restaurant.fact_transactional_restaurant
select * from dw.Restaurant.fact_acc_restaurant



truncate table dw.restaurant.update_log

