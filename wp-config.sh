#!/bin/bash
source variables.sh

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
