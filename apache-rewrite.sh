# Enable Apache rewrite module and site configuration
sudo a2enmod rewrite
sudo a2ensite wordpress.conf
sudo systemctl reload apache2