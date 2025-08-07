-- Test AT TIME ZONE operator (SQL Server 2016+)
-- Basic AT TIME ZONE usage
SELECT dt_inserted AT TIME ZONE 'UTC' AS utc_time FROM shipment;

-- With aliased column
SELECT 
    ShipmentDate = shipment.dt_inserted AT TIME ZONE 'Central European Standard Time'
FROM shipment;

-- Chained AT TIME ZONE operations
SELECT 
    OrderDate AT TIME ZONE 'Pacific Standard Time' AT TIME ZONE 'Central European Standard Time' AS converted_time
FROM orders;

-- In WHERE clause
SELECT * FROM events
WHERE event_time AT TIME ZONE 'UTC' > '2024-01-01 00:00:00';

-- With CAST
SELECT 
    CAST(created_at AT TIME ZONE 'Eastern Standard Time' AS DATE) AS eastern_date
FROM transactions;

-- Multiple columns with AT TIME ZONE
SELECT
    start_time AT TIME ZONE 'UTC' AS start_utc,
    end_time AT TIME ZONE 'UTC' AS end_utc,
    duration_minutes = DATEDIFF(MINUTE, 
        start_time AT TIME ZONE 'UTC', 
        end_time AT TIME ZONE 'UTC')
FROM sessions;

-- With GETDATE()
SELECT GETDATE() AT TIME ZONE 'Pacific Standard Time' AS current_pacific_time;

-- In JOIN condition
SELECT *
FROM orders o
INNER JOIN shipments s 
    ON o.order_date AT TIME ZONE 'UTC' = s.ship_date AT TIME ZONE 'UTC';

-- Common timezone values
SELECT 
    dt AT TIME ZONE 'UTC' AS utc_time,
    dt AT TIME ZONE 'Eastern Standard Time' AS est_time,
    dt AT TIME ZONE 'Central Standard Time' AS cst_time,
    dt AT TIME ZONE 'Mountain Standard Time' AS mst_time,
    dt AT TIME ZONE 'Pacific Standard Time' AS pst_time,
    dt AT TIME ZONE 'Central European Standard Time' AS cet_time
FROM datetime_table;