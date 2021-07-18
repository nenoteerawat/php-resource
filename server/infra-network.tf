locals {
  azs = ["${var.region}a", "${var.region}b", "${var.region}c"]
}

resource "aws_vpc" "module_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = var.name
  }
}

resource "aws_security_group" "module_secure_group" {
  name        = "${var.name}_secure_group"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.module_vpc.id

  ingress {
    description = "Mysql from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.module_vpc.cidr_block]
    # ipv6_cidr_blocks = [aws_vpc.module_vpc.ipv6_cidr_block]
  }

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
  ingress {
    description      = "Http for webpage index"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = var.name
  }
}

resource "aws_subnet" "module_private_subnet" {
  count             = 3
  vpc_id            = aws_vpc.module_vpc.id
  cidr_block        = element(cidrsubnets(aws_vpc.module_vpc.cidr_block, 4, 4, 4), count.index)
  availability_zone = element(local.azs, count.index)
  tags = {
    Name = var.name
  }
}

resource "aws_internet_gateway" "module_private_gateway" {
  vpc_id = aws_vpc.module_vpc.id

  tags = {
    Name = var.name
  }
}

resource "aws_route_table" "module_private_rt" {
  count  = 3
  vpc_id = aws_vpc.module_vpc.id

  tags = {
    Name = var.name
  }
}

resource "aws_route" "mudule_private_r" {
  count                  = 3
  route_table_id         = element(aws_route_table.module_private_rt.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = element(aws_internet_gateway.module_private_gateway.*.id, count.index)
}

resource "aws_route_table_association" "module_private_rta" {
  count     = 3
  subnet_id = element(aws_subnet.module_private_subnet.*.id, count.index)
  route_table_id = element(
    aws_route_table.module_private_rt.*.id,
    count.index
  )
}
