#!/bin/bash
source variables.sh

# Download and extract WordPress
sudo mkdir -p $WP_DIR
curl https://wordpress.org/latest.tar.gz | sudo -u www-data tar zx -C $WP_DIR

# check if wordpress is installed
if [ -d "$WP_DIR" ]; then
    echo "WordPress is already installed."
    exit 0
fi

# Set permissions
sudo chown www-data: $WP_DIR
sudo find $WP_DIR -type d -exec chmod 750 {} \;
sudo find $WP_DIR -type f -exec chmod 640 {} \;

echo "WordPress downloaded and extracted successfully."