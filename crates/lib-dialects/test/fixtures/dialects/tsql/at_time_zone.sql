-- Test case 1: Basic AT TIME ZONE usage
SELECT GETDATE() AT TIME ZONE 'UTC';
SELECT order_date AT TIME ZONE 'Eastern Standard Time' FROM orders;

-- Test case 2: Complex expressions with AT TIME ZONE
SELECT 
    meeting_id,
    scheduled_time,
    scheduled_time AT TIME ZONE 'UTC' AS utc_time,
    DATEADD(HOUR, 2, scheduled_time) AT TIME ZONE 'Pacific Standard Time' AS adjusted_pst
FROM meetings
WHERE scheduled_time AT TIME ZONE 'UTC' BETWEEN '2024-01-01' AND '2024-12-31';

-- Test case 3: Nested function calls with AT TIME ZONE
SELECT 
    CONVERT(VARCHAR(20), SYSDATETIMEOFFSET() AT TIME ZONE 'Mountain Standard Time', 120) AS formatted_mst
FROM sys.tables;

-- Test case 4: Chained AT TIME ZONE conversions
SELECT 
    event_timestamp AT TIME ZONE 'Pacific Standard Time' AT TIME ZONE 'UTC' AS double_converted
FROM events;

-- Triple chaining
SELECT 
    log_time AT TIME ZONE 'Central Standard Time' 
            AT TIME ZONE 'UTC' 
            AT TIME ZONE 'Tokyo Standard Time' AS tokyo_time
FROM system_logs;

-- Test case 5: AT TIME ZONE in JOIN conditions
SELECT 
    a.event_id,
    b.response_id
FROM event_log a
INNER JOIN response_log b 
    ON a.event_time AT TIME ZONE 'UTC' = b.response_time AT TIME ZONE 'UTC'
    AND a.category = b.category;

-- Multiple AT TIME ZONE in complex JOIN
SELECT *
FROM headquarters h
LEFT JOIN branches b
    ON h.close_time AT TIME ZONE 'Eastern Standard Time' 
     > b.open_time AT TIME ZONE 'Pacific Standard Time';

-- Test case 6: AT TIME ZONE with CASE expressions
SELECT 
    order_id,
    CASE 
        WHEN region = 'US_WEST' THEN order_time AT TIME ZONE 'Pacific Standard Time'
        WHEN region = 'US_EAST' THEN order_time AT TIME ZONE 'Eastern Standard Time'
        WHEN region = 'EU' THEN order_time AT TIME ZONE 'Central European Standard Time'
        ELSE order_time AT TIME ZONE 'UTC'
    END AS local_time
FROM global_orders;

-- Nested CASE with AT TIME ZONE
SELECT 
    CASE 
        WHEN DATEPART(HOUR, event_time AT TIME ZONE 'UTC') >= 12 
        THEN 'Afternoon'
        ELSE 'Morning'
    END AS time_of_day
FROM events;

-- Test case 7: AT TIME ZONE with aggregate and window functions
SELECT 
    DATE(transaction_time AT TIME ZONE 'UTC') AS transaction_date,
    COUNT(*) AS daily_count,
    MAX(transaction_time AT TIME ZONE 'Eastern Standard Time') AS last_transaction_est
FROM transactions
GROUP BY DATE(transaction_time AT TIME ZONE 'UTC')
HAVING MAX(transaction_time AT TIME ZONE 'UTC') > '2024-01-01';

-- Window functions with AT TIME ZONE
SELECT 
    user_id,
    login_time AT TIME ZONE 'Pacific Standard Time' AS pst_login,
    LAG(login_time AT TIME ZONE 'Pacific Standard Time', 1) 
        OVER (PARTITION BY user_id ORDER BY login_time) AS previous_pst_login
FROM user_sessions;

-- Test case 8: AT TIME ZONE in subqueries and CTEs
SELECT 
    employee_id,
    (SELECT MAX(check_in AT TIME ZONE 'UTC') 
     FROM attendance 
     WHERE attendance.emp_id = employees.employee_id) AS last_checkin_utc
FROM employees;

-- CTE with AT TIME ZONE
WITH timezone_data AS (
    SELECT 
        record_id,
        created_at AT TIME ZONE 'Mountain Standard Time' AS mst_time,
        modified_at AT TIME ZONE 'Mountain Standard Time' AS mst_modified
    FROM audit_log
)
SELECT * FROM timezone_data
WHERE mst_time > DATEADD(DAY, -7, GETDATE() AT TIME ZONE 'Mountain Standard Time');

-- EXISTS with AT TIME ZONE
SELECT * FROM orders o
WHERE EXISTS (
    SELECT 1 FROM shipments s
    WHERE s.order_id = o.order_id
    AND s.ship_date AT TIME ZONE 'UTC' <= o.required_date AT TIME ZONE 'UTC'
);