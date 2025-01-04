#!/bin/bash

source variables.sh
# Update package list and install necessary packages
sudo apt update
sudo apt install -y apache2 mysql-server php php-mysql libapache2-mod-php php-cli php-curl php-zip php-xml php-mbstring curl tar

# Start and enable Apache and MySQL services
sudo systemctl start apache2
sudo systemctl enable apache2
sudo systemctl start mysql
sudo systemctl enable mysql

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

# Download and extract WordPress
sudo mkdir -p $WP_DIR
curl -L https://wordpress.org/latest.tar.gz | sudo tar -xz --strip-components=1 -C $WP_DIR

# Set permissions
sudo chown -R www-data:www-data $WP_DIR
sudo find $WP_DIR -type d -exec chmod 750 {} \;
sudo find $WP_DIR -type f -exec chmod 640 {} \;

# Create Apache virtual host configuration
sudo bash -c "cat > $APACHE_CONF <<EOF
<VirtualHost *:80>
    ServerAdmin webmaster@$DOMAIN
    DocumentRoot $WP_DIR
    ServerName $DOMAIN
    <Directory $WP_DIR>
        AllowOverride All
        Require all granted
    </Directory>
    ErrorLog \${APACHE_LOG_DIR}/wordpress_error.log
    CustomLog \${APACHE_LOG_DIR}/wordpress_access.log combined
</VirtualHost>
EOF"

# Enable Apache rewrite module and site configuration
sudo a2enmod rewrite
sudo a2ensite wordpress.conf
sudo systemctl reload apache2

# Create WordPress wp-config.php with database settings
sudo cp $WP_DIR/wp-config-sample.php $WP_DIR/wp-config.php
sudo sed -i "s/database_name_here/$DB_NAME/" $WP_DIR/wp-config.php
sudo sed -i "s/username_here/$DB_USER/" $WP_DIR/wp-config.php
sudo sed -i "s/password_here/$DB_PASS/" $WP_DIR/wp-config.php

# Generate and set unique authentication keys and salts
SALT=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)
sudo sed -i "/AUTH_KEY/d" $WP_DIR/wp-config.php
sudo sed -i "/SECURE_AUTH_KEY/d" $WP_DIR/wp-config.php
sudo sed -i "/LOGGED_IN_KEY/d" $WP_DIR/wp-config.php
sudo sed -i "/NONCE_KEY/d" $WP_DIR/wp-config.php
sudo sed -i "/AUTH_SALT/d" $WP_DIR/wp-config.php
sudo sed -i "/SECURE_AUTH_SALT/d" $WP_DIR/wp-config.php
sudo sed -i "/LOGGED_IN_SALT/d" $WP_DIR/wp-config.php
sudo sed -i "/NONCE_SALT/d" $WP_DIR/wp-config.php
sudo sed -i "/#@-/a $SALT" $WP_DIR/wp-config.php

# Set file permissions for wp-config.php
sudo chmod 640 $WP_DIR/wp-config.php

echo "WordPress installation and configuration completed."
echo "Please complete the installation through the web interface by visiting http://$DOMAIN"
