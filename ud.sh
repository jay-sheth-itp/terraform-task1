#!/bin/bash

# Update the package manager and install the LAMP stack
sudo yum update -y
sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2

# Install Apache and start the service
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd

# Add the current user to the Apache group and update the ownership of the /var/www directory
sudo usermod -a -G apache $USER
sudo chown -R $USER:apache /var/www
sudo chmod 2775 /var/www
sudo find /var/www -type d -exec chmod 2775 {} \;
sudo find /var/www -type f -exec chmod 0664 {} \;

# Install required PHP modules and restart Apache and PHP-FPM
sudo yum install -y php-mbstring php-xml
sudo systemctl restart httpd
sudo systemctl restart php-fpm

# Download and configure phpMyAdmin
cd /var/www/html
sudo wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz
sudo mkdir phpMyAdmin && sudo tar -xvzf phpMyAdmin-latest-all-languages.tar.gz -C phpMyAdmin --strip-components 1
sudo rm phpMyAdmin-latest-all-languages.tar.gz
sudo cp phpMyAdmin/config.sample.inc.php phpMyAdmin/config.inc.php
sudo sed -i "s/localhost/${endpoint1}/g" phpMyAdmin/config.inc.php
# Create a test PHP file to verify the installation
echo '<?php phpinfo(); ?>' > /var/www/html/phpinfo.php