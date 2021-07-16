resource "aws_lb" "mudule_frontend_lb" {
  name               = "${var.name}-frontend-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.module_secure_group.id]
  subnets            = [aws_subnet.module_subnet.id, aws_subnet.module_subnet_second.id]

  # enable_deletion_protection = true

  tags = {
    Name = var.name
  }
}

resource "aws_lb_listener" "mudule_frontend_lb_listener" {
  load_balancer_arn = aws_lb.mudule_frontend_lb.arn
  port              = "80"
  protocol          = "HTTP"
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mudule_frontend_lb_tg.arn
  }
}

resource "aws_lb_target_group" "mudule_frontend_lb_tg" {
  name     = "${var.name}-frontend-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.module_vpc.id
}

resource "aws_launch_template" "module_frontend_lt" {
  name_prefix   = "${var.name}_frontent_lt"
  image_id      = var.ami_image
  instance_type = var.instance_type
  key_name      = aws_key_pair.module_key_pair_ec_frontend.key_name

  user_data = filebase64("user-data.sh")

  lifecycle {
    create_before_destroy = true
  }

  network_interfaces {
    security_groups             = [aws_security_group.module_secure_group.id]
    associate_public_ip_address = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = var.name
    }
  }
}

resource "aws_autoscaling_group" "mudule_frontend_as_group" {
  name                = "${var.name}_frontend_as_group"
  min_size            = 1
  max_size            = 2
  vpc_zone_identifier = [aws_subnet.module_subnet.id, aws_subnet.module_subnet_second.id]

  # load_balancers = [aws_elb.mudule_frontend_elb.name]
  target_group_arns = [aws_lb_target_group.mudule_frontend_lb_tg.arn]

  lifecycle {
    create_before_destroy = true
  }
  launch_template {
    id      = aws_launch_template.module_frontend_lt.id
    version = "$Latest"
  }
}

resource "aws_key_pair" "module_key_pair_ec_frontend" {
  key_name   = var.key_name_ec2_frontend
  public_key = file("keys/key-php-service-frontend.pub")
}