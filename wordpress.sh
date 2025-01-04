#!/bin/bash
source variables.sh


# check if wordpress is installed
if [ -d "$WP_DIR" ]; then
    echo "WordPress is already installed."
    exit 0
fi


# Download and extract WordPress
sudo mkdir -p $WP_DIR
curl -L https://wordpress.org/latest.tar.gz | sudo tar -xz --strip-components=1 -C $WP_DIR


# Set permissions
sudo chown www-data: $WP_DIR
sudo find $WP_DIR -type d -exec chmod 750 {} \;
sudo find $WP_DIR -type f -exec chmod 640 {} \;

echo "WordPress downloaded and extracted successfully."