#!/bin/bash

# Update system packages
sudo apt update

# Install Apache, MySQL, PHP, and other dependencies
sudo apt install -y apache2 mysql-server php libapache2-mod-php php-mysql php-gd php-xml php-mbstring

# Enable required Apache modules
sudo a2enmod rewrite
sudo a2enmod headers

# Restart Apache
sudo systemctl restart apache2

# Download DVWA from GitHub
sudo git clone https://github.com/ethicalhack3r/DVWA.git /var/www/html/dvwa

# Configure MySQL for DVWA
sudo mysql -e "CREATE DATABASE IF NOT EXISTS dvwa;"
sudo mysql -e "CREATE USER 'dvwa'@'localhost' IDENTIFIED BY 'p@ssw0rd';"
sudo mysql -e "GRANT ALL PRIVILEGES ON dvwa.* TO 'dvwa'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Copy the DVWA config file
sudo cp /var/www/html/dvwa/config/config.inc.php.dist /var/www/html/dvwa/config/config.inc.php

# Set the security level to low
sudo sed -i "s/'default_security_level' = 'impossible'/'default_security_level' = 'low'/" /var/www/html/dvwa/config/config.inc.php

# Enable allow_url_fopen and allow_url_include in php.ini
sudo sed -i 's/;allow_url_fopen = Off/allow_url_fopen = On/' /etc/php/8.1/apache2/php.ini
sudo sed -i 's/;allow_url_include = Off/allow_url_include = On/' /etc/php/8.1/apache2/php.ini

# Change permissions
sudo chown -R www-data:www-data /var/www/html/dvwa/
sudo chmod -R 755 /var/www/html/dvwa/

# Set DVWA as the default website
sudo sed -i 's@DocumentRoot /var/www/html@DocumentRoot /var/www/html/dvwa@' /etc/apache2/sites-available/000-default.conf
sudo sed -i 's@<Directory /var/www/html>@<Directory /var/www/html/dvwa>@' /etc/apache2/sites-available/000-default.conf

# Restart Apache again
sudo systemctl restart apache2

echo "DVWA setup complete!"
