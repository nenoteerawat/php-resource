#!/bin/bash
sudo yum update -y
sudo yum install unzip -y
sudo yum install php -y
sudo amazon-linux-extras enable php7.4
sudo yum install php-cli php-pdo php-fpm php-json php-mysqlnd -y
sudo yum install -y httpd
sudo yum install telnet telnet-server -y
sudo yum install mod_ssl -y
sudo systemctl start httpd
sudo systemctl enable httpd
sudo usermod -a -G apache ${var.login_user_ec2}
sudo chown -R ec2-user:apache /var/www
sudo chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \\;
find /var/www -type f -exec sudo chmod 0664 {} \\;
sudo yum install php-mbstring -y
sudo yum install php-xml -y
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { \
          echo 'Installer verified'; \
        } else { \
          echo 'Installer corrupt'; unlink('composer-setup.php'); \
        } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer
mkdir -p /etc/httpd/ssl
echo "<?php phpinfo(); ?>" > /var/www/html/index.php

sudo yum update
sudo yum install -y ruby
sudo yum install -y wget
cd /home/ec2-user
wget https://aws-codedeploy-ap-southeast-1.s3.ap-southeast-1.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
