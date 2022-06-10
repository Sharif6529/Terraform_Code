locals {
  services_java = toset(var.service_name_java)
}

resource "aws_appautoscaling_target" "service_java" {
  for_each           = local.services_java
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${var.app}-${var.env}/${each.key}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  depends_on         = [aws_alb_listener.https]
}

resource "aws_appautoscaling_policy" "service_memory_java" {
  for_each           = local.services_java
  name               = "${each.key}-memory"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.service_java["${each.key}"].resource_id
  scalable_dimension = aws_appautoscaling_target.service_java["${each.key}"].scalable_dimension
  service_namespace  = aws_appautoscaling_target.service_java["${each.key}"].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value = var.memory_target_value
  }
  depends_on = [aws_appautoscaling_target.service_java]
}

resource "aws_appautoscaling_policy" "service_cpu_java" {
  for_each           = local.services_java
  name               = "${each.key}-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.service_java["${each.key}"].resource_id
  scalable_dimension = aws_appautoscaling_target.service_java["${each.key}"].scalable_dimension
  service_namespace  = aws_appautoscaling_target.service_java["${each.key}"].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = var.cpu_target_value
  }
  depends_on = [aws_appautoscaling_target.service_java]
}


locals {
  services_python = toset(var.service_name_python)
}

resource "aws_appautoscaling_target" "service_python" {
  for_each     = local.services_python
  max_capacity = var.max_capacity
  //min_capacity       = 5 * var.min_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${var.app}-${var.env}/${each.key}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  depends_on         = [aws_alb_listener.https]
}

resource "aws_appautoscaling_policy" "service_memory_python" {
  for_each           = local.services_python
  name               = "${each.key}-memory"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.service_python["${each.key}"].resource_id
  scalable_dimension = aws_appautoscaling_target.service_python["${each.key}"].scalable_dimension
  service_namespace  = aws_appautoscaling_target.service_python["${each.key}"].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value = var.memory_target_value
  }
  depends_on = [aws_appautoscaling_target.service_python]
}

resource "aws_appautoscaling_policy" "service_cpu_python" {
  for_each           = local.services_python
  name               = "${each.key}-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.service_python["${each.key}"].resource_id
  scalable_dimension = aws_appautoscaling_target.service_python["${each.key}"].scalable_dimension
  service_namespace  = aws_appautoscaling_target.service_python["${each.key}"].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = var.cpu_target_value
  }
  depends_on = [aws_appautoscaling_target.service_python]
}


resource "aws_appautoscaling_policy" "sqs_classification_queue_consumed_scale_up" {
  name               = "classify-fg-sqs_based_scale_up-policy"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.service_python["classify-fg"].resource_id
  scalable_dimension = aws_appautoscaling_target.service_python["classify-fg"].scalable_dimension
  service_namespace  = aws_appautoscaling_target.service_python["classify-fg"].service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ExactCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 500
      metric_interval_upper_bound = 1000
      scaling_adjustment          = "10"
    }
    step_adjustment {
      metric_interval_lower_bound = 1000
      metric_interval_upper_bound = 2000
      scaling_adjustment          = "20"
    }
    step_adjustment {
      metric_interval_lower_bound = 2000
      metric_interval_upper_bound = 3000
      scaling_adjustment          = "30"
    }
    step_adjustment {
      metric_interval_lower_bound = 3000
      scaling_adjustment          = "40"
    }
  }
  depends_on = [aws_appautoscaling_target.service_python]
}

resource "aws_appautoscaling_policy" "sqs_classification_queue_consumed_scale_down" {
  name               = "classify-fg-sqs_based_scale_down-policy"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.service_python["classify-fg"].resource_id
  scalable_dimension = aws_appautoscaling_target.service_python["classify-fg"].scalable_dimension
  service_namespace  = aws_appautoscaling_target.service_python["classify-fg"].service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 120
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = "-1"
    }
  }

  depends_on = [aws_appautoscaling_target.service_python]
}
resource "aws_appautoscaling_policy" "sqs_field_queue_consumed_scale_up" {
  name               = "field-extraction-fg-sqs_based_scale_up-policy"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.service_python["field-extraction-fg"].resource_id
  scalable_dimension = aws_appautoscaling_target.service_python["field-extraction-fg"].scalable_dimension
  service_namespace  = aws_appautoscaling_target.service_python["field-extraction-fg"].service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ExactCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 500
      metric_interval_upper_bound = 1000
      scaling_adjustment          = "10"
    }
    step_adjustment {
      metric_interval_lower_bound = 1000
      metric_interval_upper_bound = 2000
      scaling_adjustment          = "20"
    }
    step_adjustment {
      metric_interval_lower_bound = 2000
      metric_interval_upper_bound = 3000
      scaling_adjustment          = "30"
    }
    step_adjustment {
      metric_interval_lower_bound = 3000
      scaling_adjustment          = "40"
    }
  }
  depends_on = [aws_appautoscaling_target.service_python]
}

resource "aws_appautoscaling_policy" "sqs_field_queue_consumed_scale_down" {
  name               = "field-extraction-fg-sqs_based_scale_down-policy"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.service_python["field-extraction-fg"].resource_id
  scalable_dimension = aws_appautoscaling_target.service_python["field-extraction-fg"].scalable_dimension
  service_namespace  = aws_appautoscaling_target.service_python["field-extraction-fg"].service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 120
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = "-1"
    }
  }

  depends_on = [aws_appautoscaling_target.service_python]
}

resource "aws_autoscaling_policy" "ec2_policy_up" {
  name                   = "ec2_policy_up"
  scaling_adjustment     = 5
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 100
  autoscaling_group_name = aws_autoscaling_group.ec2-asg.name
}

resource "aws_autoscaling_policy" "ec2_policy_down" {
  name                   = "ec2_policy_down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 100
  autoscaling_group_name = aws_autoscaling_group.ec2-asg.name
}

