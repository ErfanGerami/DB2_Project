create or alter procedure main_proc AS
BEGIN
    insert into LOG (procedure_name, time, description, effected_table, number_of_rows)
    values ('main_proc', getdate(), 'start', 'main_proc', 0);


    EXEC Hotel.Fill_Room_Status;
    EXEC Hotel.Fill_Country;
    EXEC Hotel.Fill_Tier;
    EXEC Hotel.Fill_Category;
    EXEC Hotel.Fill_Employee;
    EXEC Hotel.Fill_Room;
    EXEC Hotel.Fill_Guest;
    EXEC Hotel.Fill_Item;
    EXEC Hotel.Fill_service;
    EXEC Hotel.Fill_service_detail;
    EXEC Hotel.Fill_booking;
    EXEC Hotel.Fill_Employee;

    insert into LOG (procedure_name, time, description, effected_table, number_of_rows)
    values ('main_proc', getdate(), 'end', 'main_proc', 0);

END;
GO


