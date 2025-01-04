#!/bin/bash
source variables.sh

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

echo "Apache virtual host configuration created successfully."