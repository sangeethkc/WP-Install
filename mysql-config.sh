#!/bin/bash

source variables.sh

# restart mysql service
sudo systemctl restart mysql

# Check if MySQL is running
if ! systemctl is-active --quiet mysql; then
    echo "MySQL service failed to start. Exiting."
    exit 1
fi

echo "Waiting for MySQL to be ready..."
until mysqladmin ping -h "127.0.0.1" --silent; do
    echo "MySQL is not ready. Retrying in 2 seconds..."
    sleep 2
done
echo "MySQL is ready!"


# Secure MySQL setup
echo "Securing MySQL..."
sudo mysql --defaults-file=/dev/null --user=root <<EOF
-- Use mysql_native_password for the root user
ALTER USER 'root'@'$DB_HOST' IDENTIFIED WITH mysql_native_password BY '$DB_PASS';
FLUSH PRIVILEGES;
EOF


# Check if MySQL root password was set successfully
if [ $? -ne 0 ]; then
    echo "Failed to configure MySQL root user. Exiting."
    exit 1
fi
echo "MySQL root user configured successfully."

echo "MySQL configuration completed successfully."