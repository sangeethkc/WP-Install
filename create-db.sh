#!/bin/bash
source variables.sh


# Create WordPress database and user
mysql -u root -p"$DB_PASS" <<EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
EOF

# Verify WordPress database and user setup
if [ $? -eq 0 ]; then
    echo "WordPress database and user created successfully."
else
    echo "Failed to create WordPress database or user. Exiting."
    exit 1
fi

echo "WordPress database and user created successfully."
