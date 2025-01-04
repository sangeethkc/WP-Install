#!/bin/bash

source variables.sh

# Secure MySQL installation (automate the 'mysql_secure_installation' steps)
sudo mysql -e "UPDATE mysql.user SET Password=PASSWORD('$DB_PASS') WHERE User='root';"
sudo mysql -e "DELETE FROM mysql.user WHERE User='';"
sudo mysql -e "DROP DATABASE IF EXISTS test;"
sudo mysql -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Create WordPress database and user
sudo mysql -u root -p"$DB_PASS" -e "CREATE DATABASE $DB_NAME;"
sudo mysql -u root -p"$DB_PASS" -e "CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';"
sudo mysql -u root -p"$DB_PASS" -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';"
sudo mysql -u root -p"$DB_PASS" -e "FLUSH PRIVILEGES;"
