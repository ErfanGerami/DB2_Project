
create or alter procedure Hotel.fill_dim_tier
as BEGIN
    insert into log(procedure_name, time, description, effected_table, number_of_rows)
    values ('Hotel.fill_dim_itier', getdate(), 'start', 'hotel.dim_tier', 0);

    truncate table hotel.dim_tier;
    insert into LOG(procedure_name, time, description, effected_table, number_of_rows)
    values ('Hotel.fill_dim_tier', getdate(), 'truncate table hotel.dim_tier', 'hotel.dim_tier', @@ROWCOUNT);
    insert into hotel.dim_tier(tier_id, type, points_to_reach, discount_per_service, discount_per_booking)
    select tier_id, type, points_to_reach, discount_per_service, discount_per_booking from sa.hotel.tier
    
    insert into LOG(procedure_name, time, description, effected_table, number_of_rows)
    values ('Hotel.fill_dim_tier', getdate(), 'insert into hotel.dim_tier', 'hotel.dim_tier', @@ROWCOUNT);
    insert into LOG(procedure_name, time, description, effected_table, number_of_rows)
    values ('Hotel.fill_dim_tier', getdate(), 'end', 'hotel.dim_tier', 0);

END


GO



CREATE OR ALTER PROCEDURE Hotel.fill_dim_tier_first_load
AS BEGIN
    INSERT INTO log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES ('Hotel.fill_dim_tier_first_load', GETDATE(), 'start', 'hotel.dim_tier', 0);

    TRUNCATE TABLE hotel.dim_tier;

    INSERT INTO LOG(procedure_name, time, description, effected_table, number_of_rows)
    VALUES ('Hotel.fill_dim_tier_first_load', GETDATE(), 'truncate table hotel.dim_tier', 'hotel.dim_tier', @@ROWCOUNT);
    insert into hotel.dim_tier(tier_id, type, points_to_reach, discount_per_service, discount_per_booking)
    select tier_id, type, points_to_reach, discount_per_service, discount_per_booking from sa.hotel.tier
    


    INSERT INTO LOG(procedure_name, time, description, effected_table, number_of_rows)
    VALUES ('Hotel.fill_dim_tier_first_load', GETDATE(), 'insert into hotel.dim_tier', 'hotel.dim_tier', @@ROWCOUNT);

    INSERT INTO LOG(procedure_name, time, description, effected_table, number_of_rows)
    VALUES ('Hotel.fill_dim_tier_first_load', GETDATE(), 'end', 'hotel.dim_tier', 0);
END;
GO
exec hotel.fill_dim_tier_first_load