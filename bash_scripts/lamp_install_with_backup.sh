#!/bin/bash

# Installs the LAMP stack + Wordpress template on an Ubuntu server (Linux, Apache2, MySQL, PHP, Wordpress).
# Single instance (snowflake).
# Author Susanna Persson
# Modified to fit 2dv517 Acme install from backup.

# NOTE: Some commands assume that the file acme_wordpress_files_and_data.tar.gz is present.
# Transfer this file with this command:
# scp -i .ssh/YOURKEY.pem path/to/acme_wordpress_files_and_data.tar.gz ubuntu@INSTANCEIP:.

root_user_password="2dv517"
wordpressuser_password="wordpress"

cd ~

# Installs Apache 2
echo "****************** Apache 2 installation starting... ******************"
if which apache2 > /dev/null; then
  echo "Apache2 is already installed... skipping"
else
  sudo apt-get update
  sudo apt-get install apache2 -y
fi
echo "****************** Apache 2 installation complete! ******************"
echo "Apache2 version:"
apache2 -v
echo ""

# Installs MySQL
echo "****************** MySQL installation starting... ******************"
if which mysql > /dev/null; then
  echo "MySQL is already installed... skipping"
else
  sudo apt-get update
  sudo apt-get install mysql-server -y

  # Replaces mysql_secure_install
  # From: https://stackoverflow.com/questions/24270733/automate-mysql-secure-installation-with-echo-command-via-a-shell-script
  # Make sure that NOBODY can access the server without a password
  sudo mysql -e "UPDATE mysql.user SET authentication_string = PASSWORD('$root_user_password') WHERE User = 'root';"
  # Kill the anonymous users
  sudo mysql -e "DROP USER ''@'localhost';"
  # Because our hostname varies we'll use some Bash magic here.
  sudo mysql -e "DROP USER ''@'$(hostname)';"
  # Kill off the demo database
  sudo mysql -e "DROP DATABASE test;"
  # Make our changes take effect
  sudo mysql -e "FLUSH PRIVILEGES;"
  # Any subsequent tries to run queries this way will get access denied because lack of usr/pwd param

  # Sets the root user to use password
  sudo mysql -u root -p$root_user_password -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$root_user_password';"
  sudo mysql -u root -p$root_user_password -e "FLUSH PRIVILEGES;"

fi
echo "****************** MySQL installation complete! ******************"
echo "MySQL-server version:"
mysql --version
echo ""

# Installs PHP
echo "****************** PHP installation starting... ******************"
if which php > /dev/null; then
  echo "PHP is already installed... skipping"
else
  sudo apt-get install php libapache2-mod-php php-mysql -y
fi

echo "Configuring Apache2 for php..."
cat <<EOF > /etc/apache2/mods-enabled/dir.conf
<IfModule mod_dir.c>
        DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm
</IfModule>
EOF

echo "****************** PHP installation complete! ******************"
echo "PHP version:"
php -v
echo ""

# Setting up virtual hosts
echo "Configuring Apache 2..."

# Create directory structure and permissions
sudo mkdir -p /var/www/html/public_html
sudo chown -R $USER:$USER /var/www/html/public_html
sudo chmod -R 755 /var/www

# Create new virtual host files
# sudo touch /etc/apache2/sites-available/acme.example.com.conf

# Edit config for first site
sudo cat <<EOF > acme.example.com.conf
<VirtualHost *:80>
  ServerAdmin admin@acme.example.com
  ServerName acme.example.com
  ServerAlias www.acme.example.com
  DocumentRoot /var/www/html/public_html
  ErrorLog ${APACHE_LOG_DIR}/error.log
  CustomLog ${APACHE_LOG_DIR}/access.log combined
<Directory /var/www/html/public_html/>
    AllowOverride All
</Directory>
</VirtualHost>
EOF

sudo mv acme.example.com.conf /etc/apache2/sites-available/acme.example.com.conf

# Change root index file
sudo sed -i 's=index.html=public_html/index.php=' /etc/apache2/mods-enabled/dir.conf

# Enabling the new site, disabling the default
echo "Enabling the new sites..."
sudo a2ensite acme.example.com.conf

echo "Disable the default site..."
sudo a2dissite 000-default.conf

echo "Restarting Apache2..."
sudo systemctl restart apache2

echo "****************** Wordpress installation starting... ******************"
if grep grep wp_version /var/www/html/public_html/wp-includes/version.php > /dev/null; then
  echo "Wordpress is already installed... skipping"
else
  # Create database and database user for WP to use
  sudo mysql -u root -p$root_user_password -e "CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
  sudo mysql -u root -p$root_user_password -e "CREATE USER 'wordpress'@'localhost' IDENTIFIED BY 'wordpress'";
  sudo mysql -u root -p$root_user_password -e "GRANT ALL PRIVILEGES ON wordpress.* TO wordpress@localhost;"

  # sudo mysql -u root -p$root_user_password -e "GRANT ALL ON wordpress.* TO 'wordpressuser'@'localhost' IDENTIFIED BY '$wordpressuser_password';"
  sudo mysql -u root -p$root_user_password -e "FLUSH PRIVILEGES;"

  # Enabling rewrite module
  sudo a2enmod rewrite
  sudo systemctl restart apache2

  # Restore from backup Wordpress tar. Working from root dir, assuming acme_wordpress_files.gz and backup.sql is present in dir.
  # Untar the course provided file
  tar xvf acme_wordpress_files_and_data.tar.gz

  # Untar the actual backup
  tar xvf acme_wordpress_files.tar.gz -C /var/www/html/public_html/
  sed -i 's/db:3306/localhost/' /var/www/html/public_html/wp-config.php
  sudo mysql -u root -p$root_user_password wordpress < backup.sql

  # Gets unique key values and saves them to a temporary file
  curl -s https://api.wordpress.org/secret-key/1.1/salt/ > ./salts

  # Saves another temporary file with a setting
  cat <<EOF > ./fsmethod
define('FS_METHOD', 'direct');

EOF

  # Concatenates the two temp files with wp-config and saves to a new temp file
  cat /var/www/html/public_html/wp-config.php ./salts ./fsmethod  > ./tempfile
  # Overwrites wp-config with the new concatenated file
  sudo cp tempfile /var/www/html/public_html/wp-config.php

  # Removes the temp files
  sudo rm ./salts ./fsmethod ./tempfile
fi

echo "****************** Wordpress installation complete! ******************"
echo "Wordpress version:"
grep wp_version /var/www/html/public_html/wp-includes/version.php | awk -F "'" '{print $2}'
echo ""

echo "Restarting Apache2..."
sudo systemctl restart apache2
