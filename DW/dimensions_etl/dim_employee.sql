CREATE OR ALTER PROCEDURE Hotel.fill_dim_employee_first_load
AS BEGIN
    INSERT INTO log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES ('Hotel.fill_dim_employee_first_load', GETDATE(), 'start', 'hotel.dim_employee', 0);

    insert into hotel.dim_employee (
        employee_id, national_code, birthday, role_id,
        first_name, last_name, phone_number, address,
        salary, hire_date, is_active
    )
    SELECT employee_id, national_code, birthday, role_id,
           first_name, last_name, phone_number, address,
           salary, hire_date, is_active
    FROM SA.hotel.employee;
    INSERT INTO LOG(procedure_name, time, description, effected_table, number_of_rows)
    VALUES ('Hotel.fill_dim_employee_first_load', GETDATE(), 'insert into hotel.dim_employee', 'hotel.dim_employee', @@ROWCOUNT);

    INSERT INTO Log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES ('Hotel.fill_dim_employee_first_load', GETDATE(), 'end', 'hotel.dim_employee', 0);
END;
GO




CREATE OR ALTER PROCEDURE Hotel.fill_dim_employee
AS
BEGIN
    INSERT INTO log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES ('Hotel.fill_dim_employee', GETDATE(), 'start', 'hotel.dim_employee', 0);

    DECLARE @Changes TABLE (
        action_type NVARCHAR(10)
    );

    MERGE hotel.dim_employee AS target
    USING SA.hotel.employee AS source
    ON target.employee_id = source.employee_id

    WHEN MATCHED AND target.salary != source.salary THEN
        UPDATE SET 
            effective_salary_date = DATEADD(day, -1, CAST(GETDATE() AS date)),
            previous_salary = target.salary,
            salary = source.salary

    WHEN NOT MATCHED BY TARGET THEN
        INSERT (
            employee_id, national_code, birthday, role_id,
            first_name, last_name, phone_number, address,
            salary, hire_date, is_active, gender
        )
        VALUES (
            source.employee_id, source.national_code, source.birthday, source.role_id,
            source.first_name, source.last_name, source.phone_number, source.address,
            source.salary, source.hire_date, source.is_active, source.gender
        )
    OUTPUT $action INTO @Changes;

    ;WITH actions(action, rows) AS ( 
        SELECT action_type, COUNT(*) FROM @Changes GROUP BY action_type
    )
    INSERT INTO Log(procedure_name, time, description, effected_table, number_of_rows)
    SELECT 'Hotel.fill_dim_employee', GETDATE(), action, 'hotel.dim_employee', rows
    FROM actions;

    UPDATE emp
    SET emp.is_active = source.is_active
    FROM hotel.dim_employee emp
    JOIN SA.hotel.employee source ON emp.employee_id = source.employee_id;

    INSERT INTO Log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES ('Hotel.fill_dim_employee', GETDATE(), 'update is_active', 'hotel.dim_employee', @@ROWCOUNT);

    INSERT INTO Log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES ('Hotel.fill_dim_employee', GETDATE(), 'end', 'hotel.dim_employee', 0);
END;


