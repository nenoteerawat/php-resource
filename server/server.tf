variable "name" {
  type = string
}

resource "aws_instance" "module_ec2" {
  ami           = "ami-018c1c51c7a13e363"
  instance_type = "t2.micro"
  tags = {
    name = "${var.name}_server"
  }
}

resource "aws_vpc" "module_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    name = "${var.name}_vpc"
  }
}

resource "aws_security_group" "module_secure_group" {
  name        = "${var.name}_secure_group"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.module_vpc.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.module_vpc.cidr_block]
    # ipv6_cidr_blocks = [aws_vpc.module_vpc.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    name = "${var.name}_secure_group"
  }
}

resource "aws_subnet" "module_subnet" {
  vpc_id     = aws_vpc.module_vpc.id
  cidr_block = cidrsubnet(aws_vpc.module_vpc.cidr_block, 4, 1)

  tags = {
    name = "${var.name}_subnet"
  }
}

resource "aws_internet_gateway" "module_gateway" {
  vpc_id = aws_vpc.module_vpc.id

  tags = {
    name = "${var.name}_gateway"
  }
}

resource "aws_route_table" "module_route_table" {
  vpc_id = aws_vpc.module_vpc.id

  route = []

  tags = {
    name = "${var.name}_route_table"
  }
}
