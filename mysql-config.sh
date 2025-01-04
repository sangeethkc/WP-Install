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

read -p "MySQL server superior username. E.g. root: " DB_USER
read -p "MySQL server superior password: " DB_PASS

if [ -z "$DB_USER" ]
then
  DB_USER="root"
fi

if [ -z "$DB_PASS" ]
then
  DB_PASS="root123"
fi


mysql -h $DB_HOST -u $DB_USER -p$DB_PASS <<SHELL
  create user '$DB_USER'@'$USER_HOST' identified by '$DB_PASS';
  create database if not exists $DB_NAME;
  grant alter,create,delete,drop,index,lock tables,insert,select,update on $DB_NAME.* to '$DB_USER'@'$USER_HOST';
  flush privileges;
  quit
SHELL

# Database created.
echo -e "\033[32mSuccess\033[0m: Database has been created successfully!"


# sudo mysql -u root -e "SELECT user, host, plugin FROM mysql.user WHERE user = 'root';"

# sudo mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root123';"
# sudo mysql -u root -e "FLUSH PRIVILEGES;"

# sudo mysql -u root -p'root123' -e "CREATE DATABASE $DB_NAME;"


# # Secure MySQL installation (automate the 'mysql_secure_installation' steps)
# sudo mysql -e "UPDATE mysql.user SET Password=PASSWORD('$DB_PASS') WHERE User='root';"
# sudo mysql -e "DELETE FROM mysql.user WHERE User='';"
# sudo mysql -e "DROP DATABASE IF EXISTS test;"
# sudo mysql -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
# sudo mysql -e "FLUSH PRIVILEGES;"

# echo "MySQL configuration completed successfully."