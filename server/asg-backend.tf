resource "aws_lb" "module_backend_lb" {
  name               = "${var.name}-backend-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.module_secure_group.id]
  subnets            = aws_subnet.module_private_subnet.*.id

  # enable_deletion_protection = true

  tags = {
    Name = var.name
  }
}

resource "aws_lb_listener" "module_backend_lb_listener" {
  load_balancer_arn = aws_lb.module_backend_lb.arn
  port              = "80"
  protocol          = "HTTP"
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.module_backend_lb_tg.arn
  }
}

resource "aws_lb_target_group" "module_backend_lb_tg" {
  name     = "${var.name}-backend-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.module_vpc.id
}

resource "aws_launch_template" "module_backend_lt" {
  name_prefix   = "${var.name}_backend_lt"
  image_id      = var.ami_image
  instance_type = var.instance_type
  key_name      = aws_key_pair.module_key_pair_ec_backend.key_name
  iam_instance_profile {
    name = aws_iam_instance_profile.module_ec2_iam_instance_profile.name
  }

  user_data = filebase64("user-data-backend.sh")

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
      Name = "${var.name}-backend"
    }
  }
}

resource "aws_autoscaling_group" "mudule_backend_as_group" {
  name                      = "${var.name}_backend_as_group"
  min_size                  = 1
  max_size                  = 3
  vpc_zone_identifier       = aws_subnet.module_private_subnet.*.id
  health_check_grace_period = 300
  health_check_type         = "ELB"

  target_group_arns = [aws_lb_target_group.module_backend_lb_tg.arn]

  min_elb_capacity = 1

  lifecycle {
    create_before_destroy = true
  }
  launch_template {
    id      = aws_launch_template.module_backend_lt.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_policy" "module_backend_as_policy" {
  name                   = "${var.name}_backend_as_policy"
  autoscaling_group_name = aws_autoscaling_group.mudule_backend_as_group.name
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 60.0
  }
}

resource "aws_key_pair" "module_key_pair_ec_backend" {
  key_name   = var.key_name_ec2_backend
  public_key = file("keys/key-php-service-backend.pub")
}
