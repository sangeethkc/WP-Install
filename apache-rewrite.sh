# Enable Apache rewrite module and site configuration
sudo a2ensite wordpress.conf
sudo a2enmod rewrite
sudo systemctl reload apache2

echo "Apache rewrite module and site configuration enabled successfully."