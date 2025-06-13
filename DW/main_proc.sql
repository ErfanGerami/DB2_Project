
create or alter procedure hotel.main_proc_first_load AS  
BEGIN

    insert into log (procedure_name, time, description, effected_table, number_of_rows)
    values ('main_proc_first_load', getdate(), 'start', 'main_proc_first_load', 0);
    exec Hotel.fill_dim_room_first_load;
    exec hotel.fill_dim_item_first_load;
    exec hotel.fill_dim_employee_first_load;
    exec hotel.fill_dim_room_status_first_load;
    exec hotel.fill_dim_guest_first_load;
    exec hotel.fill_fact_transactional_service_first_load;
    exec hotel.fill_fact_transactional_booking_first_load;
    exec hotel.fill_fact_daily_hotel_first_load;
    exec hotel.fill_fact_acc_hotel_first_load;

    insert into log (procedure_name, time, description, effected_table, number_of_rows)
    values ('main_proc_first_load', getdate(), 'end', 'main_proc_first_load', 0);

END;
GO
create or alter procedure hotel.main_proc AS  
BEGIN

    insert into log (procedure_name, time, description, effected_table, number_of_rows)
    values ('main_proc', getdate(), 'start', 'main_proc', 0);
     exec Hotel.fill_dim_room;
    exec hotel.fill_dim_item;
    exec hotel.fill_dim_employee;
    exec hotel.fill_dim_room_status;
    exec hotel.fill_dim_guest;
    exec hotel.fill_fact_transactional_service;
    exec hotel.fill_fact_transactional_booking;
    exec hotel.fill_fact_daily_hotel;
    exec hotel.fill_fact_acc_hotel;

    insert into log (procedure_name, time, description, effected_table, number_of_rows)
    values ('main_proc', getdate(), 'end', 'main_proc', 0);

END;

exec hotel.main_proc_first_load

