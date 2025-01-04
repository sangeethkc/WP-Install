#!/bin/bash

# Exit on error
set -e

# Update system
apt-get update
apt-get upgrade -y

# Install LAMP stack
apt-get install -y apache2 mysql-server php php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip

# Start services
systemctl start apache2
systemctl start mysql

# Configure MySQL
mysql_secure_installation <<EOF

y
password123
password123
y
y
y
y
EOF

# Create WordPress database
mysql -u root -ppassword123 <<EOF
CREATE DATABASE wordpress;
CREATE USER 'wordpressuser'@'localhost' IDENTIFIED BY 'wordpress123';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpressuser'@'localhost';
FLUSH PRIVILEGES;
EOF

# Download and configure WordPress
cd /var/www/html
rm -rf index.html
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp -r wordpress/* .
rm -rf wordpress latest.tar.gz

# Set permissions
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Create wp-config.php
cp wp-config-sample.php wp-config.php
sed -i "s/database_name_here/wordpress/" wp-config.php
sed -i "s/username_here/wordpressuser/" wp-config.php
sed -i "s/password_here/wordpress123/" wp-config.php

# Generate and set security keys
SECURITY_KEYS=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)
sed -i "/define( 'AUTH_KEY'/,/define( 'NONCE_SALT'/{/define( 'AUTH_KEY'/i\\$SECURITY_KEYS" wp-config.php
sed -i "/define( 'AUTH_KEY'/,/define( 'NONCE_SALT'/d" wp-config.php

# Configure Apache
cat > /etc/apache2/sites-available/wordpress.conf <<EOF
<VirtualHost *:80>
    DocumentRoot /var/www/html
    ServerName localhost
    
    <Directory /var/www/html>
        AllowOverride All
    </Directory>
</VirtualHost>
EOF

# Enable Apache modules and configuration
a2enmod rewrite
a2ensite wordpress
a2dissite 000-default
systemctl restart apache2

echo "WordPress installation complete. Access http://localhost to complete setup."