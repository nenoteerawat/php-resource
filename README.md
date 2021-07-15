# PHP resource

Aws terraform for deploy php website

## Prerequire

### MacOs

Install require program for development

``` shell
brew install warrensbox/tap/tfswitc
brew install pre-commit gawk terraform-docs tflint tfsec coreutils checkov terrascan
```

## Pre-commit setup

``` shell
pre-commit autoupdate
pre-commit install
```

If you encountered with issues. Run this command

``` shell
pre-commit clean
```

## Terraform Run

``` shell
terraform get -update=true
terraform init -backend-config=config/backend.conf
terraform plan -var-file=config/dev.tfvars
terraform apply -var-file=config/dev.tfvars
```

## SSH key generate

``` shell
ssh-keygen -t rsa -q -f {key-name} -N ''
```

## RDS MYSQL
```
    mysql -h php-service.cmw6el8utq3k.ap-southeast-1.rds.amazonaws.com -P 3306 -u admin -p

    mysql> create database mydb;
    mysql> use mydb;
    mysql> source db_backup.dump;
```

## Info
```
frontend: http://ec2-13-213-187-49.ap-southeast-1.compute.amazonaws.com/
backend:  http://ec2-46-137-244-237.ap-southeast-1.compute.amazonaws.com/

Deploy PHP

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"

php composer.phar install
php composer.phar update

SSL
# openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout botman-web-selfsigned.key -out botman-web-selfsigned.crt

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt
openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
cat /etc/ssl/certs/dhparam.pem | sudo tee -a /etc/ssl/certs/apache-selfsigned.crt
```
...
