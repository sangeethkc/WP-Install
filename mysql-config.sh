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

# Automate MySQL secure installation
sudo mysql --defaults-file=/dev/null <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$DB_PASS';
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
EOF

echo "MySQL configuration completed successfully."