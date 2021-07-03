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
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

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
  vpc_id            = aws_vpc.module_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.module_vpc.cidr_block, 8, 1)
  availability_zone = "ap-southeast-1a"
  tags = {
    name = "${var.name}_subnet"
  }
}

resource "aws_subnet" "module_subnet_second" {
  vpc_id            = aws_vpc.module_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.module_vpc.cidr_block, 8, 2)
  availability_zone = "ap-southeast-1b"
  tags = {
    name = "${var.name}_subnet_second"
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

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.module_gateway.id
  }
  tags = {
    name = "${var.name}_route_table"
  }
}

resource "aws_route_table_association" "subnet_association" {
  subnet_id      = aws_subnet.module_subnet.id
  route_table_id = aws_route_table.module_route_table.id
}
