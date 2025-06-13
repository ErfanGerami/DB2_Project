




CREATE OR ALTER PROCEDURE Hotel.fill_dim_guest_first_load
AS BEGIN
    INSERT INTO log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES ('Hotel.fill_dim_guest_first_load', GETDATE(), 'start', 'hotel.dim_guest', 0);

    TRUNCATE TABLE hotel.dim_guest;

    INSERT INTO LOG(procedure_name, time, description, effected_table, number_of_rows)
    VALUES ('Hotel.fill_dim_guest_first_load', GETDATE(), 'truncate table hotel.dim_guest', 'hotel.dim_guest', @@ROWCOUNT);

    INSERT INTO hotel.dim_guest (
        guest_id, first_name, last_name, national_code, phone_number,
        country_id, country_name, country_code,
        email, points,
        tier_id, tier_type, tier_points_to_reach,
        discount_for_service, discount_for_stay
    )
    SELECT guest_id, first_name, last_name, national_code, phone_number,
           g.country_id, c.country_name, c.country_code,
           email, points,
           g.tier_id, type, points_to_reach,
           discount_for_service, discount_for_stay
    FROM SA.hotel.guest g
    JOIN SA.hotel.country c ON g.country_id = c.country_id
    JOIN SA.hotel.tier t ON g.tier_id = t.tier_id;

    INSERT INTO LOG(procedure_name, time, description, effected_table, number_of_rows)
    VALUES ('Hotel.fill_dim_guest_first_load', GETDATE(), 'insert into hotel.dim_guest', 'hotel.dim_guest', @@ROWCOUNT);

    INSERT INTO LOG(procedure_name, time, description, effected_table, number_of_rows)
    VALUES ('Hotel.fill_dim_guest_first_load', GETDATE(), 'end', 'hotel.dim_guest', 0);
END;
GO





create or alter procedure Hotel.fill_dim_guest
as BEGIN
    insert into log(procedure_name, time, description, effected_table, number_of_rows)
    values ('Hotel.fill_dim_guest', getdate(), 'start', 'hotel.dim_guest', 0);

    truncate table hotel.dim_guest;
    insert into LOG(procedure_name, time, description, effected_table, number_of_rows)
        values ('Hotel.fill_dim_guest', getdate(), 'truncate table hotel.dim_guest', 'hotel.dim_guest', @@ROWCOUNT);
        insert into hotel.dim_guest (
            guest_id, first_name, last_name, national_code, phone_number,
            country_id, country_name, country_code,
            email, points,
            tier_id, tier_type, tier_points_to_reach,
            discount_for_service, discount_for_stay
        )
        select
            guest_id, first_name, last_name, national_code, phone_number,
            g.country_id, c.country_name, c.country_code,
            email, points,
            g.tier_id, type, points_to_reach,
            discount_for_service, discount_for_stay
        from SA.hotel.guest g JOIN SA.hotel.country c ON g.country_id = c.country_id
        JOIN SA.hotel.tier t ON g.tier_id = t.tier_id;

        insert into LOG(procedure_name, time, description, effected_table, number_of_rows)
        values ('Hotel.fill_dim_guest', getdate(), 'insert into hotel.dim_guest', 'hotel.dim_guest', @@ROWCOUNT);

        insert into LOG(procedure_name, time, description, effected_table, number_of_rows)
        values ('Hotel.fill_dim_guest', getdate(), 'end', 'hotel.dim_guest', 0);
    END;

GO


