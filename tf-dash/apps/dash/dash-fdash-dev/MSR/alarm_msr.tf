resource "aws_cloudwatch_metric_alarm" "classification_service_msr_sqs_usage_high" {
  alarm_name          = "classify-fg-msr-sqs-usage-above-threshold"
  alarm_description   = "This alarm monitors classify-fg-msr sqs usage for scaling up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = "60"
  statistic           = "Average"
  threshold           = "500"
  alarm_actions       = ["${aws_appautoscaling_policy.sqs_classification_queue_msr_consumed_scale_up.arn}"]

  dimensions = {
    QueueName = "fdash-msr-page-classification-req-${var.env}"
  }
}

# A CloudWatch alarm that monitors cpu usage of containers for scaling down
resource "aws_cloudwatch_metric_alarm" "classification_service_msr_sqs_usage_low" {
  alarm_name          = "classify-fg-msr-sqs-usage-below-threshold"
  alarm_description   = "This alarm monitors classify-fg-msr sqs usage for scaling down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = "60"
  statistic           = "Average"
  threshold           = "500"
  alarm_actions       = ["${aws_appautoscaling_policy.sqs_classification_queue_msr_consumed_scale_down.arn}"]

  dimensions = {
    QueueName = "fdash-msr-page-classification-req-${var.env}"
  }
}

resource "aws_cloudwatch_metric_alarm" "field-extraction_msr_service_sqs_usage_high" {
  alarm_name          = "field-extraction-msr-fg-sqs-usage-above-threshold"
  alarm_description   = "This alarm monitors field-extraction-msr-fg sqs usage for scaling up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = "60"
  statistic           = "Average"
  threshold           = "500"
  alarm_actions       = ["${aws_appautoscaling_policy.sqs_field_queue_msr_consumed_scale_up.arn}"]

  dimensions = {
    QueueName = "fdash-msr-page-field-extraction-req-${var.env}"
  }
}

# A CloudWatch alarm that monitors cpu usage of containers for scaling down



resource "aws_cloudwatch_metric_alarm" "field-extraction_msr_service_sqs_usage_low" {
  alarm_name          = "field-extraction-fg-msr-sqs-usage-below-threshold"
  alarm_description   = "This alarm monitors field-extraction-fg-msr sqs usage for scaling down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = "60"
  statistic           = "Average"
  threshold           = "500"
  alarm_actions       = ["${aws_appautoscaling_policy.sqs_field_queue_msr_consumed_scale_down.arn}"]

  dimensions = {
    QueueName = "fdash-msr-page-field-extraction-req-${var.env}"
  }
}

resource "aws_cloudwatch_metric_alarm" "ec2_msr_cpu_alarm_down" {
  alarm_name          = "ec2_msr_cpu_alarm_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "10"

  dimensions = {
    AutoScalingGroupName = var.autoscaling_group_msr
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.ec2_msr_policy_down.arn]
}

resource "aws_cloudwatch_metric_alarm" "ec2_msr_cpu_alarm_up" {
  alarm_name          = "ec2_msr_cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "60"

  dimensions = {
    AutoScalingGroupName = var.autoscaling_group_msr
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.ec2_msr_policy_up.arn]
}
