#!/bin/bash

# Check if running with root privileges
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run with root privileges. Please use sudo or run as root."
   exit 1
fi

# Customized progress messages
progress_messages=(
    "Check prerequisites..."
    "Set up DVWA..."
    "Configure MySQL..."
    "Configure Apache..."
    "Enable allow_url_include..."
    "Restarting Apache..."
    "_____________________________"
    "_____________________________"
    "--Initialising installation--"
    "_____________________________"
    "_____________________________"
   )

# Randomized ASCII banners
banner=(
"  ######  #     # #     #    #                       "
" #     # #     # #  #  #   # #                      "
" #     # #     # #  #  #  #   #                     "
" #     # #     # #  #  # #     #                    "
" #     #  #   #  #  #  # #######                    "
" #     #   # #   #  #  # #     #                    "
"  ######     #     ## ##  #     #                    "
"                                                    "
"                                                    "
"  ####  #####  ###### #####  # #####  ####          "
" #    # #    # #      #    # #   #   #              "
" #      #    # #####  #    # #   #    ####          "
" #      #####  #      #    # #   #        #         "
" #    # #   #  #      #    # #   #   #    #         "
"  ####  #    # ###### #####  #   #    ####          "
"                                                    "
"  #####  ######                                      "
" #     # #     # #    # #####  ######  ####  #    # "
" # ### # #     # #    # #    # #      #      #    # "
" # ### # ######  #    # #    # #####   ####  ###### "
" # ####  #   #   #    # #####  #           # #    # "
" #       #    #  #    # #      #      #    # #    # "
"  #####  #     #  ####  #      ######  ####  #    # "
)


# Function for typing effect with time delay
function type_effect() {
    str=$1
    delay=$2
    for ((i=0; i<${#str}; i++)); do
        echo -n "${str:$i:1}"
        sleep $delay
    done
}

# Select a random banner
random_index=$((RANDOM % ${#banners[@]}))
banner="${banners[$random_index]}"

# Display random banner
echo "$banner"
echo

# Display customized progress messages with time delay
echo "DVWA Setup customized by Rupesh"
echo

for message in "${progress_messages[@]}"; do
    echo -n "➡ "
    type_effect "$message" 0.05
    echo
    sleep 1
done

echo
echo "@credits Rupesh Pandey"

# Update system packages
echo
type_effect "➡ Checking prerequisites..." 0.05
echo
apt update
sleep 1

# Install Apache, MySQL, PHP, and other dependencies
echo
type_effect "➡ Setting up DVWA..." 0.05
echo
apt install -y apache2 mysql-server php libapache2-mod-php php-mysql php-gd php-xml php-mbstring
sleep 1

# Enable required Apache modules
echo
type_effect "➡ Configuring Apache..." 0.05
echo
a2enmod rewrite
a2enmod headers
sleep 1

# Restart Apache
echo
type_effect "➡ Restarting Apache..." 0.05
echo
systemctl restart apache2
sleep 1

# Download DVWA from GitHub
echo
type_effect "➡ Configuring MySQL..." 0.05
echo
git clone https://github.com/ethicalhack3r/DVWA.git /var/www/html/dvwa
sleep 1

# Configure MySQL for DVWA
echo
type_effect "➡ Configuring MySQL..." 0.05
echo
mysql -e "CREATE DATABASE IF NOT EXISTS dvwa;"
mysql -e "CREATE USER 'dvwa'@'localhost' IDENTIFIED BY 'p@ssw0rd';"
mysql -e "GRANT ALL PRIVILEGES ON dvwa.* TO 'dvwa'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"
sleep 1

# Copy the DVWA config file
echo
type_effect "➡ Copying DVWA config file..." 0.05
echo
cp /var/www/html/dvwa/config/config.inc.php.dist /var/www/html/dvwa/config/config.inc.php
sleep 1

# Set the security level to low
echo
type_effect "➡ Setting security level to low..." 0.05
echo
sed -i "s/'default_security_level' = 'impossible'/'default_security_level' = 'low'/" /var/www/html/dvwa/config/config.inc.php
sleep 1

# Enable allow_url_fopen and allow_url_include in php.ini
echo
type_effect "➡ Enabling allow_url_fopen and allow_url_include..." 0.05
echo
sed -i 's/;allow_url_fopen = Off/allow_url_fopen = On/' /etc/php/8.1/apache2/php.ini
sed -i 's/allow_url_include = Off/allow_url_include = On/' /etc/php/8.1/apache2/php.ini
sleep 1

# Change permissions
echo
type_effect "➡ Changing permissions..." 0.05
echo
chown -R www-data:www-data /var/www/html/dvwa/
chmod -R 755 /var/www/html/dvwa/
sleep 1

# Set DVWA as the default website
echo
type_effect "➡ Setting DVWA as default website..." 0.05
echo
sed -i 's@DocumentRoot /var/www/html@DocumentRoot /var/www/html/dvwa@' /etc/apache2/sites-available/000-default.conf
sed -i 's@<Directory /var/www/html>@<Directory /var/www/html/dvwa>@' /etc/apache2/sites-available/000-default.conf
sleep 1

# Restart Apache again
echo
type_effect "➡ Restarting Apache..." 0.05
echo
systemctl restart apache2
sleep 1

echo
echo "DVWA setup complete!"
echo "username = admin , Password = password"
echo "@credits Rupesh Pandey"

