#!/bin/bash
# update system and install packages
apt update -y
apt install -y apache2 php php-mysql libapache2-mod-php mysql-server unzip wget

# Setup MySQL root password and import db
MYSQL_ROOT_PASSWORD="#admin123"

# Configure MySQL root user password and allow login
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASSWORD}'; FLUSH PRIVILEGES;"

# Import the DB dump (will be copied via Terraform)
mysql -uroot -p${MYSQL_ROOT_PASSWORD} < /home/ubuntu/db_dump.sql

# Install phpMyAdmin non-interactively
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password ${MYSQL_ROOT_PASSWORD}" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password ${MYSQL_ROOT_PASSWORD}" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password ${MYSQL_ROOT_PASSWORD}" | debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
DEBIAN_FRONTEND=noninteractive apt install -y phpmyadmin

# Enable phpMyAdmin
ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf-enabled/phpmyadmin.conf
systemctl restart apache2

# Allow remote MySQL access
sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
systemctl restart mysql