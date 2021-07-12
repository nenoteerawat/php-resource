resource "aws_instance" "module_ec2_frontend" {
  ami                    = var.ami_image
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.module_secure_group.id]
  subnet_id              = aws_subnet.module_subnet.id
  iam_instance_profile   = var.iam_instance_profile_name
  key_name               = aws_key_pair.module_key_pair_ec_frontend.key_name

  # This EC2 Instance has a public IP and will be accessible directly from the public Internet
  associate_public_ip_address = true
  tags = {
    Name = "${var.name}_frontend_server"
  }
}

resource "aws_eip" "ec2_frontend_eip" {
  vpc      = true
  instance = aws_instance.module_ec2_frontend.id
}

resource "null_resource" "module_frontend_provisioner" {

  triggers = {
    public_ip = aws_eip.ec2_frontend_eip.public_ip
  }

  connection {
    type = "ssh"
    host = aws_eip.ec2_frontend_eip.public_ip
    user = var.login_user_ec2
    # port = 22
    agent       = true
    private_key = file("keys/key-php-service-frontend")
  }

  provisioner "remote-exec" { # Install apache, mysql client, php
    inline = [
      "sudo yum update -y",
      "sudo yum install unzip -y",
      "sudo yum install php -y",
      # "sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2",
      "sudo amazon-linux-extras enable php7.4",
      "sudo yum install php-cli php-pdo php-fpm php-json php-mysqlnd -y",
      "sudo yum install -y httpd",
      "sudo yum install telnet telnet-server -y",
      "sudo yum install mod_ssl -y",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      "sudo usermod -a -G apache ${var.login_user_ec2}",
      "sudo chown -R ec2-user:apache /var/www",
      "sudo chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \\;",
      "find /var/www -type f -exec sudo chmod 0664 {} \\;",
      "sudo yum install php-mbstring -y",
      "sudo yum install php-xml -y",
      "php -r \"copy('https://getcomposer.org/installer', 'composer-setup.php');\"",
      "php -r \"if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;\"",
      "php composer-setup.php",
      "php -r \"unlink('composer-setup.php');\"",
      "sudo mv composer.phar /usr/local/bin/composer",
      "mkdir -p /etc/httpd/ssl",
    ]
  }

  provisioner "file" { # Copy the index file form local to remote
    source      = "src/botman-web"
    destination = "/tmp/src"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/src/* /var/www/html/",
    ]
  }
}

resource "aws_instance" "module_ec2_backend" {
  ami                    = var.ami_image
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.module_secure_group.id]
  subnet_id              = aws_subnet.module_subnet.id
  iam_instance_profile   = var.iam_instance_profile_name
  key_name               = aws_key_pair.module_key_pair_ec_frontend.key_name

  # This EC2 Instance has a public IP and will be accessible directly from the public Internet
  associate_public_ip_address = true
  tags = {
    Name = "${var.name}_backend_server"
  }
}

resource "aws_eip" "ec2_backend_eip" {
  vpc      = true
  instance = aws_instance.module_ec2_backend.id
}

resource "null_resource" "module_backend_provisioner" {

  triggers = {
    public_ip = aws_eip.ec2_backend_eip.public_ip
  }

  connection {
    type = "ssh"
    host = aws_eip.ec2_backend_eip.public_ip
    user = var.login_user_ec2
    # port = 22
    agent       = true
    private_key = file("keys/key-php-service-frontend")
  }

  provisioner "remote-exec" { # Install apache, mysql client, php
    inline = [
      "sudo yum update -y",
      "sudo yum install unzip -y",
      "sudo yum install php -y",
      "sudo amazon-linux-extras install -y",
      "sudo amazon-linux-extras enable php7.4",
      "sudo yum install php-cli php-pdo php-fpm php-json php-mysqlnd -y",
      "sudo yum install -y httpd",
      "sudo yum install telnet telnet-server -y",
      "sudo yum install mod_ssl -y",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      "sudo usermod -a -G apache ${var.login_user_ec2}",
      "sudo chown -R ec2-user:apache /var/www",
      "sudo chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \\;",
      "find /var/www -type f -exec sudo chmod 0664 {} \\;",
      "sudo yum install php-mbstring -y",
      "sudo yum install php-xml -y",
      "php -r \"copy('https://getcomposer.org/installer', 'composer-setup.php');\"",
      "php -r \"if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;\"",
      "php composer-setup.php",
      "php -r \"unlink('composer-setup.php');\"",
      "sudo mv composer.phar /usr/local/bin/composer",
      "mkdir -p /etc/httpd/ssl",
    ]
  }

  provisioner "file" { # Copy the index file form local to remote
    source      = "src/botman-engine"
    destination = "/tmp/src"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/src/* /var/www/html/",
    ]
  }
}

resource "aws_key_pair" "module_key_pair_ec_frontend" {
  key_name   = var.key_name_ec2_frontend
  public_key = file("keys/key-php-service-frontend.pub")
}
