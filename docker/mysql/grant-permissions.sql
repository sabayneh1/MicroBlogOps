GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'New1234@yes' WITH GRANT OPTION;
FLUSH PRIVILEGES;

-- Add a log statement for confirmation
SELECT 'Permissions granted successfully' AS Status;
