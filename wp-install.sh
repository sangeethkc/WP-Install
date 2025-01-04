#!/bin/bash

source variables.sh

echo "WordPress installation and configuration completed."
echo "Please complete the installation through the web interface by visiting http://$DOMAIN"

# do a curl to the domain to check if the installation is successful
curl -I http://$DOMAIN

if [ $? -eq 0 ]; then
    echo "WordPress installation successful"
else
    echo "WordPress installation failed"
fi
