
CREATE OR ALTER PROCEDURE Hotel.fill_dim_room_first_load
AS BEGIN
    INSERT INTO Log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES ('Hotel.fill_dim_room_first_load', GETDATE(), 'start', '', 0);
    DECLARE @Changes TABLE (action_type NVARCHAR(10));
    truncate table hotel.dim_room
    INSERT INTO LOG(procedure_name, time, description, effected_table, number_of_rows)
    VALUES ('Hotel.fill_dim_room_first_load', GETDATE(), 'truncate table hotel.dim_room', 'hotel.dim_room', @@ROWCOUNT);

    insert into hotel.dim_room(
        room_id, capacity, floor, room_number,
        number_of_single_bed, number_of_double_bed, cost_per_day,
        status_id, status_name, status_description,
        start_date, end_date, current_flag
    )select 
        room_id, capacity, floor, room_number,
        number_of_single_bed, number_of_double_bed, cost_per_day,
        r.status_id, status_name, description,
        CAST(GETDATE() AS date), NULL, 1
    from SA.hotel.room r
    join SA.hotel.room_status s on r.status_id = s.status_id;
    INSERT INTO LOG(procedure_name, time, description, effected_table, number_of_rows)
    VALUES ('Hotel.fill_dim_room_first_load', GETDATE(), 'insert into hotel.dim_room', 'hotel.dim_room', @@ROWCOUNT);
    INSERT INTO Log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES ('Hotel.fill_dim_room_first_load', GETDATE(), 'end', 'hotel.dim_room', 0);
END;
GO

create or alter procedure Hotel.fill_dim_room
as BEGIN

    INSERT INTO Log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES ('Hotel.fill_dim_room', GETDATE(), 'start', '', 0);

    DECLARE @Changes TABLE (
        action_type NVARCHAR(10)
    );



    BEGIN TRANSACTION;

    WITH SourceWithStatus AS (
        SELECT 
            r.room_id, r.capacity, r.floor, r.room_number,
            r.number_of_single_bed, r.number_of_double_bed, r.cost_per_day,
            r.status_id, s.status_name, s.description AS status_description
        FROM SA.hotel.room r
        JOIN SA.hotel.room_status s ON r.status_id = s.status_id
    )
    MERGE hotel.dim_room AS target
    USING SourceWithStatus AS source
    ON target.room_id = source.room_id

    WHEN MATCHED AND target.cost_per_day != source.cost_per_day THEN
        UPDATE SET 
            end_date = DATEADD(day, -1, CAST(GETDATE() AS date)),
            current_flag = 0

    WHEN NOT MATCHED BY TARGET THEN
        INSERT (
            room_id, capacity, floor, room_number,
            number_of_single_bed, number_of_double_bed, cost_per_day,
            status_id, status_name, status_description,
            start_date, end_date, current_flag
        )
        VALUES (
            source.room_id, source.capacity, source.floor, source.room_number,
            source.number_of_single_bed, source.number_of_double_bed, source.cost_per_day,
            source.status_id, source.status_name, source.status_description,
            CAST(GETDATE() AS date), NULL, 1
        )

    OUTPUT $action INTO @Changes;
    WITH SourceWithStatus AS (
        SELECT 
            r.room_id, r.capacity, r.floor, r.room_number,
            r.number_of_single_bed, r.number_of_double_bed, r.cost_per_day,
            r.status_id, s.status_name, s.description AS status_description
        FROM SA.hotel.room r
        JOIN SA.hotel.room_status s ON r.status_id = s.status_id
    )
    INSERT INTO hotel.dim_room (
        room_id, capacity, floor, room_number,
        number_of_single_bed, number_of_double_bed, cost_per_day,
        status_id, status_name, status_description,
        start_date, end_date, current_flag
    )
    SELECT 
        s.room_id, s.capacity, s.floor, s.room_number,
        s.number_of_single_bed, s.number_of_double_bed, s.cost_per_day,
        s.status_id, s.status_name, s.status_description,
        CAST(GETDATE() AS date), NULL, 1
    FROM SourceWithStatus s
    JOIN hotel.dim_room d ON s.room_id = d.room_id
    WHERE d.current_flag = 0
    AND s.cost_per_day != d.cost_per_day
    AND NOT EXISTS (
        SELECT 1 FROM hotel.dim_room d2
        WHERE d2.room_id = s.room_id AND d2.current_flag = 1
    );

    -- Log rows inserted from step above
    INSERT INTO Log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES ('Hotel.fill_dim_room', GETDATE(), 'changed record insert', 'hotel.dim_room', @@ROWCOUNT);

    -- Log all actions from merge
    WITH actions(action, rows) AS (
        SELECT action_type, COUNT(*) FROM @Changes GROUP BY action_type
    )
    INSERT INTO Log(procedure_name, time, description, effected_table, number_of_rows)
    SELECT 'Hotel.fill_dim_room', GETDATE(), action, 'hotel.dim_room', rows
    FROM actions;

    COMMIT;

    -- Sync status fields using JOIN (faster than subqueries)
    UPDATE d
    SET 
        d.status_id = r.status_id,
        d.status_name = s.status_name,
        d.status_description = s.description
    FROM hotel.dim_room d
    JOIN SA.hotel.room r ON d.room_id = r.room_id
    JOIN SA.hotel.room_status s ON r.status_id = s.status_id
    WHERE d.status_id != r.status_id;

    -- Log status updates
    INSERT INTO Log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES ('Hotel.fill_dim_room', GETDATE(), 'updated status', 'hotel.dim_room', @@ROWCOUNT);

    -- End log
    INSERT INTO Log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES ('Hotel.fill_dim_room', GETDATE(), 'end', 'hotel.dim_room', 0);

END


select * from sa.Restaurant.category