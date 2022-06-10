locals {
  services_pri = toset(var.service_name_pri)
}

resource "aws_appautoscaling_target" "service_pri" {
  for_each           = local.services_pri
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${var.app}-PRI-${var.env}/${each.key}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  depends_on         = [var.https, aws_ecs_cluster.cluster_pri]
}

resource "aws_appautoscaling_policy" "service_memory_pri" {
  for_each           = local.services_pri
  name               = "${each.key}-memory"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.service_pri["${each.key}"].resource_id
  scalable_dimension = aws_appautoscaling_target.service_pri["${each.key}"].scalable_dimension
  service_namespace  = aws_appautoscaling_target.service_pri["${each.key}"].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value = var.memory_target_value
  }
  depends_on = [aws_appautoscaling_target.service_pri]
}

resource "aws_appautoscaling_policy" "service_cpu_pri" {
  for_each           = local.services_pri
  name               = "${each.key}-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.service_pri["${each.key}"].resource_id
  scalable_dimension = aws_appautoscaling_target.service_pri["${each.key}"].scalable_dimension
  service_namespace  = aws_appautoscaling_target.service_pri["${each.key}"].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = var.cpu_target_value
  }
  depends_on = [aws_appautoscaling_target.service_pri]
}



resource "aws_appautoscaling_policy" "sqs_classification_queue_pri_consumed_scale_up" {
  name               = "classify-fg-pri-sqs_based_scale_up-policy"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.service_pri["classify-fg"].resource_id
  scalable_dimension = aws_appautoscaling_target.service_pri["classify-fg"].scalable_dimension
  service_namespace  = aws_appautoscaling_target.service_pri["classify-fg"].service_namespace

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
  depends_on = [aws_appautoscaling_target.service_pri]
}

resource "aws_appautoscaling_policy" "sqs_classification_queue_pri_consumed_scale_down" {
  name               = "classify-fg-pri-sqs_based_scale_down-policy"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.service_pri["classify-fg"].resource_id
  scalable_dimension = aws_appautoscaling_target.service_pri["classify-fg"].scalable_dimension
  service_namespace  = aws_appautoscaling_target.service_pri["classify-fg"].service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 120
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = "-1"
    }
  }

  depends_on = [aws_appautoscaling_target.service_pri]
}
resource "aws_appautoscaling_policy" "sqs_field_queue_pri_consumed_scale_up" {
  name               = "field-extraction-fg-pri-sqs_based_scale_up-policy"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.service_pri["field-extraction-fg"].resource_id
  scalable_dimension = aws_appautoscaling_target.service_pri["field-extraction-fg"].scalable_dimension
  service_namespace  = aws_appautoscaling_target.service_pri["field-extraction-fg"].service_namespace

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
  depends_on = [aws_appautoscaling_target.service_pri]
}

resource "aws_appautoscaling_policy" "sqs_field_queue_pri_consumed_scale_down" {
  name               = "field-extraction-fg-pri-sqs_based_scale_down-policy"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.service_pri["field-extraction-fg"].resource_id
  scalable_dimension = aws_appautoscaling_target.service_pri["field-extraction-fg"].scalable_dimension
  service_namespace  = aws_appautoscaling_target.service_pri["field-extraction-fg"].service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 120
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = "-1"
    }
  }

  depends_on = [aws_appautoscaling_target.service_pri]
}

resource "aws_autoscaling_policy" "ec2_pri_policy_up" {
  name                   = "ec2_pri_policy_up"
  scaling_adjustment     = 5
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 100
  autoscaling_group_name = var.autoscaling_group_pri
}

resource "aws_autoscaling_policy" "ec2_pri_policy_down" {
  name                   = "ec2_pri_policy_down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 100
  autoscaling_group_name = var.autoscaling_group_pri
}

