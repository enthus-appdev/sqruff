-- Test Case 1: INSERT followed by SELECT (original issue from CreateOfferSource.sql)
INSERT INTO offer_source SELECT * FROM temp_source
SELECT id FROM offer_source WHERE active = 1

-- Test Case 2: UPDATE followed by SELECT
UPDATE users SET status = 'active' WHERE id = 1
SELECT * FROM users WHERE status = 'active'

-- Test Case 3: DELETE followed by INSERT
DELETE FROM logs WHERE date < '2024-01-01'
INSERT INTO archive_logs SELECT * FROM deleted_logs

-- Test Case 4: CREATE TABLE followed by INSERT
CREATE TABLE test_table (id INT, name VARCHAR(50))
INSERT INTO test_table VALUES (1, 'Test')

-- Test Case 5: Multiple consecutive DML statements
INSERT INTO table1 SELECT * FROM source1
UPDATE table2 SET col = 1 WHERE id = 2
DELETE FROM table3 WHERE status = 0
SELECT COUNT(*) FROM table1

-- Test Case 6: DECLARE followed by statements
DECLARE @var INT = 10
SET @var = 20
SELECT @var AS result

-- Test Case 7: Mixed DDL and DML without separators
CREATE TABLE new_table (id INT)
INSERT INTO new_table VALUES (1)
UPDATE new_table SET id = 2
SELECT * FROM new_table
DROP TABLE new_table