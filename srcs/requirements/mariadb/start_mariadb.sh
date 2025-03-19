#!/bin/bash
set -e  # Exit on error

# Start MariaDB service
service mysql start
sleep 10

# Create database Travel if not exists
echo "Creating new database $DATABASE"
mysql -e "CREATE DATABASE IF NOT EXISTS $DATABASE;"

# Create the table Visited_countries
echo "Creating elements inside $DATABASE"
mysql -e "USE $DATABASE; CREATE TABLE IF NOT EXISTS Visited_countries (
    country VARCHAR(50),
    nb_visits INT,
    last_visited DATE
);"

# Insert initial data into Visited_countries table
mysql -e "USE $DATABASE; INSERT INTO Visited_countries (country, nb_visits, last_visited) 
VALUES 
    ('France', 5, '2024-12-25'),
    ('Japan', 1, '2019-09-15'),
    ('USA', 3, '2016-07-01');"

# Create admin user with root privileges
echo "Creating new users $DB_ADMIN_ID && $DB_ID"
mysql -e "CREATE USER IF NOT EXISTS '${DB_ADMIN_ID}'@'%' IDENTIFIED BY '${DB_ADMIN_PWD}';"
mysql -e "GRANT ALL PRIVILEGES ON *.* TO '${DB_ADMIN_ID}'@'%' WITH GRANT OPTION;"

# Create normal user
mysql -e "CREATE USER IF NOT EXISTS '${DB_ID}'@'%' IDENTIFIED BY '${DB_PWD}';"
mysql -e "GRANT SELECT, INSERT, UPDATE ON ${DATABASE}.* TO '${DB_ID}'@'%';"

# Flush privileges to apply changes
mysql -e "FLUSH PRIVILEGES;"

echo "Users created successfully and MySQL service restart"

exec "$@"


