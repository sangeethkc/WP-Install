# Update package list and install necessary packages
sudo apt update
sudo apt install -y apache2 \
                 mysql-server \
                 php-mbstring \
                 php-mysql
                #  ghostscript \
                #  libapache2-mod-php \
                #  php \
                #  php-bcmath \
                #  php-curl \
                #  php-imagick \
                #  php-intl \
                #  php-json \
                #  php-xml \
                #  php-zip



# Start and enable Apache and MySQL services
sudo systemctl start apache2
sudo systemctl enable apache2
sudo systemctl start mysql
sudo systemctl enable mysql