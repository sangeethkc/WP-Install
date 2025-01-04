#!/bin/bash

source variables.sh

# check if mysql is installed
if ! command -v mysql &> /dev/null; then
    echo "MySQL is not installed. Please install MySQL before running this script."
    exit 1
fi

# check if mysql is running
if ! sudo systemctl is-active mysql &> /dev/null; then
    echo "MySQL is not running. Please start MySQL before running this script."
    exit 1
fi

echo "Starting WordPress database setup..."

# Create database and user
mysql -u $DB_USER -p <<EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER
    ON $DB_NAME.*
    TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
EOF

# Check if the last command was successful
if [ $? -eq 0 ]; then
    echo "WordPress database setup completed successfully!"
else
    echo "An error occurred while setting up the database."
