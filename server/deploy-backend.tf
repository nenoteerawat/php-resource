resource "aws_codedeploy_app" "module_backend_codedeploy_app" {
  compute_platform = "Server"
  name             = "${var.name}-backend-app"
}



resource "aws_codedeploy_deployment_group" "module_backend_codedeploy_group" {
  app_name               = aws_codedeploy_app.module_backend_codedeploy_app.name
  deployment_group_name  = "${var.name}-backend-codedeploy-group"
  deployment_config_name = "CodeDeployDefault.AllAtOnce"
  service_role_arn       = aws_iam_role.module_codedeploy_iam_role.arn

  autoscaling_groups = [aws_autoscaling_group.mudule_backend_as_group.id]

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }


  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  load_balancer_info {
    target_group_info {
      name = aws_lb_target_group.module_backend_lb_tg.name
    }
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout    = "STOP_DEPLOYMENT"
      wait_time_in_minutes = 60
    }

    green_fleet_provisioning_option {
      action = "COPY_AUTO_SCALING_GROUP"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 1
    }
  }
}
