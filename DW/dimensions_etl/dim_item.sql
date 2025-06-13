
create or alter procedure Hotel.fill_dim_item
as BEGIN
    insert into log(procedure_name, time, description, effected_table, number_of_rows)
    values ('Hotel.fill_dim_item', getdate(), 'start', 'hotel.dim_item', 0);

    truncate table hotel.dim_item;
    insert into LOG(procedure_name, time, description, effected_table, number_of_rows)
    values ('Hotel.fill_dim_item', getdate(), 'truncate table hotel.dim_item', 'hotel.dim_item', @@ROWCOUNT);

    insert into hotel.dim_item (item_id, item_name, category_id, category_name, category_description, duration_to_prepare, cost, charge, description)
    select 
        i.item_id,
        i.item_name,
        i.category_id,
        c.category_name,
        c.description,
        i.duration_to_prepare,
        i.cost,
        i.charge,
        i.description
    from SA.hotel.item i
    join SA.hotel.category c on i.category_id = c.category_id;
    insert into LOG(procedure_name, time, description, effected_table, number_of_rows)
    values ('Hotel.fill_dim_item', getdate(), 'insert into hotel.dim_item', 'hotel.dim_item', @@ROWCOUNT);
    insert into LOG(procedure_name, time, description, effected_table, number_of_rows)
    values ('Hotel.fill_dim_item', getdate(), 'end', 'hotel.dim_item', 0);

END


GO



CREATE OR ALTER PROCEDURE Hotel.fill_dim_item_first_load
AS BEGIN
    INSERT INTO log(procedure_name, time, description, effected_table, number_of_rows)
    VALUES ('Hotel.fill_dim_item_first_load', GETDATE(), 'start', 'hotel.dim_item', 0);

    TRUNCATE TABLE hotel.dim_item;

    INSERT INTO LOG(procedure_name, time, description, effected_table, number_of_rows)
    VALUES ('Hotel.fill_dim_item_first_load', GETDATE(), 'truncate table hotel.dim_item', 'hotel.dim_item', @@ROWCOUNT);

    INSERT INTO hotel.dim_item (
        item_id, item_name, category_id, category_name, category_description,
        duration_to_prepare, cost, charge, description
    )
    SELECT i.item_id, i.item_name, i.category_id, c.category_name, c.description,
           i.duration_to_prepare, i.cost, i.charge, i.description
    FROM SA.hotel.item i
    JOIN SA.hotel.category c ON i.category_id = c.category_id;

    INSERT INTO LOG(procedure_name, time, description, effected_table, number_of_rows)
    VALUES ('Hotel.fill_dim_item_first_load', GETDATE(), 'insert into hotel.dim_item', 'hotel.dim_item', @@ROWCOUNT);

    INSERT INTO LOG(procedure_name, time, description, effected_table, number_of_rows)
    VALUES ('Hotel.fill_dim_item_first_load', GETDATE(), 'end', 'hotel.dim_item', 0);
END;
GO