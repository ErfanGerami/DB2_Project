EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;

BULK INSERT shared.dim_date
FROM 'C:\Users\CD CENTER\Desktop\DBProject\dim_date.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,  
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK,
    CODEPAGE = '65001'  
);


select * from shared.dim_date where date_id='2025-06-15'
select count(*) from source.hotel.booking