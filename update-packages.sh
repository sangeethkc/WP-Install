# Update package list and install necessary packages
sudo apt update
sudo apt install -y apache2 mysql-server php php-mysql libapache2-mod-php php-cli php-curl php-zip php-xml php-mbstring curl tar

# Start and enable Apache and MySQL services
sudo systemctl start apache2
sudo systemctl enable apache2
sudo systemctl start mysql
sudo systemctl enable mysql