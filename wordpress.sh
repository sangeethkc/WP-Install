#!/bin/bash
source variables.sh

# Download and extract WordPress
sudo mkdir -p $WP_DIR
curl -L https://wordpress.org/latest.tar.gz | sudo tar -xz --strip-components=1 -C $WP_DIR


# Set permissions
sudo chown -R www-data:www-data $WP_DIR
sudo find $WP_DIR -type d -exec chmod 750 {} \;
sudo find $WP_DIR -type f -exec chmod 640 {} \;