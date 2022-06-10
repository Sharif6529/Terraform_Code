resource "aws_cloudwatch_log_group" "log_msr" {
  count             = length(var.log_groups_msr)
  name              = "/${element(var.log_groups_msr, count.index)}"
  retention_in_days = 90
  tags              = var.common_tags
}

resource "aws_ecs_cluster" "cluster_msr" {
  name = "${var.app}-MSR-${var.env}"
  tags = var.common_tags

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

}

resource "aws_ecs_service" "service_extract_msr" {
  name            = "extract-ec2"
  cluster         = aws_ecs_cluster.cluster_msr.id
  task_definition = aws_ecs_task_definition.task_extract_msr.arn
  desired_count   = 1
  network_configuration {
    subnets         = var.subnets
    security_groups = [var.cluster-sg, var.redis-sg]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.dashextract_msr.arn
    container_name   = var.container_name
    container_port   = var.container_port
  }
  tags = merge(var.common_tags, {

    awsecsserviceName = "fdash-extract"
  })
  propagate_tags = "SERVICE"
  # this prevents a race condition where the service can't start
  depends_on = [var.https]
}

resource "aws_ecs_service" "service_api_msr" {
  name            = "api-fg"
  cluster         = aws_ecs_cluster.cluster_msr.id
  task_definition = aws_ecs_task_definition.task_api_msr.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  network_configuration {
    subnets         = var.subnets
    security_groups = [var.cluster-sg, var.redis-sg]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.dashapi_msr.arn
    container_name   = var.container_name2
    container_port   = var.container_port2
  }
  tags = merge(var.common_tags, {

    awsecsserviceName = "fdash-api"
  })
  propagate_tags = "SERVICE"
  # this prevents a race condition where the service can't start
  depends_on = [var.https]
}

resource "aws_ecs_service" "service_classify_msr" {
  name            = "classify-fg"
  cluster         = aws_ecs_cluster.cluster_msr.id
  task_definition = aws_ecs_task_definition.task_classify_msr.arn
  launch_type     = "FARGATE"
  desired_count   = var.min_capacity
  network_configuration {
    subnets         = var.subnets
    security_groups = [var.cluster-sg, var.redis-sg]
  }
  tags = merge(var.common_tags, {

    awsecsserviceName = "fdash-classify"
  })
  propagate_tags = "SERVICE"
  # this prevents a race condition where the service can't start
}

resource "aws_ecs_service" "service_event_msr" {
  name            = "events-fg"
  cluster         = aws_ecs_cluster.cluster_msr.id
  task_definition = aws_ecs_task_definition.task_event_msr.arn
  launch_type     = "FARGATE"
  desired_count   = var.min_capacity
  network_configuration {
    subnets         = var.subnets
    security_groups = [var.cluster-sg, var.redis-sg]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.dashevents_msr.arn
    container_name   = var.container_name4
    container_port   = var.container_port4
  }
  tags = merge(var.common_tags, {

    awsecsserviceName = "fdash-events"
  })
  propagate_tags = "SERVICE"
  # this prevents a race condition where the service can't start
  depends_on = [var.https]
}

resource "aws_ecs_service" "service_field_msr" {
  name            = "field-extraction-fg"
  cluster         = aws_ecs_cluster.cluster_msr.id
  task_definition = aws_ecs_task_definition.task_field_msr.arn
  launch_type     = "FARGATE"
  desired_count   = var.min_capacity
  network_configuration {
    subnets         = var.subnets
    security_groups = [var.cluster-sg, var.redis-sg]
  }
  tags = merge(var.common_tags, {

    awsecsserviceName = "fdash-field_extraction"
  })
  propagate_tags = "SERVICE"
}

resource "aws_ecs_service" "service_comparison_msr" {
  name            = "comparison-fg"
  cluster         = aws_ecs_cluster.cluster_msr.id
  task_definition = aws_ecs_task_definition.task_comparison_msr.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  network_configuration {
    subnets         = var.subnets
    security_groups = [var.cluster-sg, var.redis-sg]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.dashcomparison_msr.arn
    container_name   = var.container_name8
    container_port   = var.container_port8
  }
  tags = merge(var.common_tags, {

    awsecsserviceName = "fdash-comparison"
  })
  propagate_tags = "SERVICE"
  # this prevents a race condition where the service can't start
  depends_on = [var.https]
}

resource "aws_ecs_service" "service_integration_msr" {
  name            = "integration-fg"
  cluster         = aws_ecs_cluster.cluster_msr.id
  task_definition = aws_ecs_task_definition.task_integration_msr.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  network_configuration {
    subnets         = var.subnets
    security_groups = [var.cluster-sg, var.redis-sg]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.dashintegration_msr.arn
    container_name   = var.container_name9
    container_port   = var.container_port9
  }
  tags = merge(var.common_tags, {

    awsecsserviceName = "fdash-integration"
  })
  propagate_tags = "SERVICE"
  # this prevents a race condition where the service can't start
  depends_on = [var.https]
}

resource "aws_ecs_service" "service_wrapper_msr" {
  name            = "wrapper-fg"
  cluster         = aws_ecs_cluster.cluster_msr.id
  task_definition = aws_ecs_task_definition.task_wrapper_msr.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  network_configuration {
    subnets         = var.subnets
    security_groups = [var.cluster-sg, var.redis-sg]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.dashwrapper_msr.arn
    container_name   = var.container_name10
    container_port   = var.container_port10
  }
  tags = merge(var.common_tags, {

    awsecsserviceName = "fdash-wrapper"
  })
  propagate_tags = "SERVICE"
  # this prevents a race condition where the service can't start
  depends_on = [var.https]
}

resource "aws_ecs_service" "service_stitching_msr" {
  name            = "stitching-fg"
  cluster         = aws_ecs_cluster.cluster_msr.id
  task_definition = aws_ecs_task_definition.task_stitching_msr.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  network_configuration {
    subnets         = var.subnets
    security_groups = [var.cluster-sg, var.redis-sg]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.dashstitching_msr.arn
    container_name   = var.container_name11
    container_port   = var.container_port11
  }
  tags = merge(var.common_tags, {

    awsecsserviceName = "fdash-stitching"
  })
  propagate_tags = "SERVICE"
  # this prevents a race condition where the service can't start
  depends_on = [var.https]
}
