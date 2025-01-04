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

mysql -u root -p$DB_PASS <<EOF
CREATE DATABASE $DB_NAME;
CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
EOF


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

echo "MySQL configuration completed successfully."