#!/bin/bash

source variables.sh

# restart mysql service
sudo systemctl restart mysql

# Check if MySQL is running
if ! systemctl is-active --quiet mysql; then
    echo "MySQL service failed to start. Exiting."
    exit 1
fi

# Secure MySQL and set root password
sudo mysql --defaults-file=/dev/null --user=root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$DB_PASS';
FLUSH PRIVILEGES;
EOF

# Check if root password setup was successful
if [ $? -ne 0 ]; then
    echo "Failed to configure MySQL root user. Exiting."
    exit 1
fi


echo "MySQL configuration completed successfully."