#!/bin/bash

# Variables
GIT_REPO_URL="https://github.com/shritechno/car-booking-portal.git"
USERNAME="shree"
PASSWORD="#shree123"  # Replace with a strong password

# Update and install packages
apt update -y
apt install -y apache2 php php-mysql mysql-client git

# Create user 'shree' with home directory and password
useradd -m "$USERNAME"
echo "$USERNAME:$PASSWORD" | chpasswd

# Make sure home directories are accessible by Apache
chmod o+x /home
chmod o+x /home/$USERNAME

# Clone the GitHub repo as user 'shree'
sudo -u "$USERNAME" git clone "$GIT_REPO_URL" /home/$USERNAME/websites

# Give Apache ownership of the website directory
chown -R www-data:www-data /home/$USERNAME/websites

# Add read & execute permissions
chmod -R 755 /home/$USERNAME/websites

# Create Apache virtual host config
cat <<EOF > /etc/apache2/sites-available/website.conf
<VirtualHost *:80>
    ServerAdmin admin@example.com
    DocumentRoot /home/$USERNAME/websites
    <Directory /home/$USERNAME/websites>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

# Enable the new site and disable the default
a2ensite website.conf
a2dissite 000-default.conf

# Restart Apache to apply changes
systemctl reload apache2
systemctl restart apache2

echo "Setup complete. Website should be running on port 80."
