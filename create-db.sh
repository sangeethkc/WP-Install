#!/bin/bash
source variables.sh

# Create WordPress database and user
sudo mysql -u root -p"$DB_PASS" -e "CREATE DATABASE $DB_NAME;"
sudo mysql -u root -p"$DB_PASS" -e "CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';"
sudo mysql -u root -p"$DB_PASS" -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';"
sudo mysql -u root -p"$DB_PASS" -e "FLUSH PRIVILEGES;"

echo "WordPress database and user created successfully."
