
resource "aws_appautoscaling_target" "default" {
  count              = var.enabled ? 1 : 0
  service_namespace  = "ecs"
  resource_id        = "service/${var.cluster_name}/${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = var.min_capacity
  max_capacity       = var.max_capacity
  role_arn           = "arn:aws:iam::211385148200:role/aws-service-role/ecs.application-autoscaling.amazonaws.com/AWSServiceRoleForApplicationAutoScaling_ECSService"

}


resource "aws_appautoscaling_policy" "up" {
  count              = var.step_enabled ? 1 : 0
  name               = "${var.name}-Policy-up"
  service_namespace  = "ecs"
  resource_id        = "service/${var.cluster_name}/${var.service_name}"
    policy_type        = "StepScaling"

  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = var.scale_up_cooldown
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = var.scale_up_adjustment
    }
    
   }

}
resource "aws_appautoscaling_policy" "down" {
  count              = var.step_enabled ? 1 : 0
  name               = "${var.name}-Policy-Down"
  service_namespace  = "ecs"
  resource_id        = "service/${var.cluster_name}/${var.service_name}"
    policy_type        = "StepScaling"

  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = var.scale_down_cooldown
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = var.scale_down_adjustment
    }
  }

}



resource "aws_cloudwatch_metric_alarm" "cloudwatch_metric_alarm_rpm_down" {
  alarm_name          = "${var.alarm_name}-RequestCountPerTarget-Low"
  alarm_description   = "Managed by Terraform"
  alarm_actions       = [aws_appautoscaling_policy.down[0].arn]
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = var.low_evaluation_periods
  #datapoints_to_alarm = 1

  metric_name         = "RequestCountPerTarget"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  statistic           = "Average"
  threshold           = var.low_threshold

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
    TargetGroup  = var.tg_arn_suffix
  }
}
resource "aws_cloudwatch_metric_alarm" "cloudwatch_metric_alarm_rpm_up" {
  alarm_name          = "${var.alarm_name}-RequestCountPerTarget-high-new"
  alarm_description   = "Managed by Terraform"
  alarm_actions       = [aws_appautoscaling_policy.up[0].arn]
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.high_evaluation_periods
    #datapoints_to_alarm = 1

  metric_name         = "RequestCountPerTarget"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = var.high_threshold

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
    TargetGroup  = var.tg_arn_suffix
  }
}