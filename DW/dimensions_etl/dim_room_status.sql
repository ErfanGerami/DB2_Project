CREATE OR ALTER PROCEDURE Hotel.fill_dim_room_status_first_load
AS BEGIN
    INSERT INTO log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES ('Hotel.fill_dim_room_status_first_load', GETDATE(), 'start', 'hotel.dim_room_status', 0);

    TRUNCATE TABLE hotel.dim_room_status;

    INSERT INTO LOG(procedure_name, time, description, effected_table, number_of_rows)
    VALUES ('Hotel.fill_dim_room_status_first_load', GETDATE(), 'truncate table hotel.dim_room_status', 'hotel.dim_room_status', @@ROWCOUNT);

    INSERT INTO hotel.dim_room_status (status_id, status_name, description)
    SELECT status_id, status_name, description
    FROM SA.hotel.room_status;

    INSERT INTO LOG(procedure_name, time, description, effected_table, number_of_rows)
    VALUES ('Hotel.fill_dim_room_status_first_load', GETDATE(), 'insert into hotel.dim_room_status', 'hotel.dim_room_status', @@ROWCOUNT);

    INSERT INTO LOG(procedure_name, time, description, effected_table, number_of_rows)
    VALUES ('Hotel.fill_dim_room_status_first_load', GETDATE(), 'end', 'hotel.dim_room_status', 0);
END;
GO

create or alter procedure HOtel.fill_dim_room_status
as BEGIN
    insert into log(procedure_name, time, description, effected_table, number_of_rows)
    values ('Hotel.fill_dim_room_status', getdate(), 'start', 'hotel.dim_room_status', 0);

    truncate table hotel.dim_room_status;
    insert into LOG(procedure_name, time, description, effected_table, number_of_rows)
    values ('Hotel.fill_dim_room_status', getdate(), 'truncate table hotel.dim_room_status', 'hotel.dim_room_status', @@ROWCOUNT);

    insert into hotel.dim_room_status (status_id, status_name, description)
    select 
        status_id,
        status_name,
        description
    from SA.hotel.room_status;

    insert into LOG(procedure_name, time, description, effected_table, number_of_rows)
    values ('Hotel.fill_dim_room_status', getdate(), 'insert into hotel.dim_room_status', 'hotel.dim_room_status', @@ROWCOUNT);
    
    insert into LOG(procedure_name, time, description, effected_table, number_of_rows)
    values ('Hotel.fill_dim_room_status', getdate(), 'end', 'hotel.dim_room_status', 0);

end;
GO

