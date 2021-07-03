resource "aws_instance" "module_ec2_frontend" {
  ami                    = "ami-018c1c51c7a13e363"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.module_secure_group.id}"]
  subnet_id              = aws_subnet.module_subnet.id
  iam_instance_profile   = data.aws_iam_instance_profile.instance_connect.name
  key_name               = aws_key_pair.module_key_pair_ec_frontend.key_name

  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo apt-get -y update",
  #     "sudo apt-get -y install nginx",
  #     "sudo service nginx start",
  #   ]
  # }

  connection {
    user = var.login_user_ec2
  }
  tags = {
    name = "${var.name}_server"
  }
}

resource "aws_key_pair" "module_key_pair_ec_frontend" {
  key_name   = var.key_name_ec2_frontend
  public_key = file("keys/key-php-service-frontend.pub")
}

resource "aws_eip" "ec2_frontend_eip" {
  vpc      = true
  instance = aws_instance.module_ec2_frontend.id
}
