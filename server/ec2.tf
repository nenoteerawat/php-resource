resource "aws_instance" "module_ec2_frontend" {
  ami                    = "ami-018c1c51c7a13e363"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.module_secure_group.id}"]
  subnet_id              = aws_subnet.module_subnet.id

  tags = {
    name = "${var.name}_server"
  }
}
