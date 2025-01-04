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

sudo mysql_secure_installation

sudo mysql -u root -p$DB_PASS <<EOF
CREATE DATABASE $DB_NAME;
CREATE USER '$DB_USER'@'$USER_HOST' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'$USER_HOST';
FLUSH PRIVILEGES;
EOF
