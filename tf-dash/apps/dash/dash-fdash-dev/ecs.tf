resource "aws_cloudwatch_log_group" "this" {
  count             = length(var.log_groups)
  name              = "/${element(var.log_groups, count.index)}"
  retention_in_days = 90
  tags              = local.common_tags
}

resource "aws_ecs_cluster" "cluster" {
  name = "${var.app}-${var.env}"
  tags = local.common_tags

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

}

resource "aws_ecs_service" "service" {
  name            = "extract-ec2"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1
  network_configuration {
    subnets         = var.subnets
    security_groups = [aws_security_group.cluster-sg.id, data.aws_security_group.redis_dash.id]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.dashextract.arn
    container_name   = var.container_name
    container_port   = var.container_port
  }
  tags = merge(local.common_tags, {

    awsecsserviceName = "fdash-extract"
  })
  propagate_tags = "SERVICE"
  # this prevents a race condition where the service can't start
  depends_on = [aws_alb_listener.https]
}

resource "aws_ecs_service" "service1" {
  name            = "ui-fg"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task1.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  network_configuration {
    subnets         = var.subnets
    security_groups = [aws_security_group.ui.id]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.dashui.arn
    container_name   = var.container_name1
    container_port   = var.container_port1
  }
  tags = merge(local.common_tags, {

    awsecsserviceName = "fdash-ui"
  })
  propagate_tags = "SERVICE"
  # this prevents a race condition where the service can't start
  depends_on = [aws_alb_listener.https]
}

resource "aws_ecs_service" "service2" {
  name            = "api-fg"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task2.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  network_configuration {
    subnets         = var.subnets
    security_groups = [aws_security_group.cluster-sg.id, data.aws_security_group.redis_dash.id]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.dashapi.arn
    container_name   = var.container_name2
    container_port   = var.container_port2
  }
  tags = merge(local.common_tags, {

    awsecsserviceName = "fdash-api"
  })
  propagate_tags = "SERVICE"
  # this prevents a race condition where the service can't start
  depends_on = [aws_alb_listener.https]
}

resource "aws_ecs_service" "service3" {
  name            = "classify-fg"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task3.arn
  launch_type     = "FARGATE"
  desired_count   = var.min_capacity
  network_configuration {
    subnets         = var.subnets
    security_groups = [aws_security_group.cluster-sg.id, data.aws_security_group.redis_dash.id]
  }
  tags = merge(local.common_tags, {

    awsecsserviceName = "fdash-classify"
  })
  propagate_tags = "SERVICE"
  # this prevents a race condition where the service can't start
}

resource "aws_ecs_service" "service4" {
  name            = "events-fg"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task4.arn
  launch_type     = "FARGATE"
  desired_count   = var.min_capacity
  network_configuration {
    subnets         = var.subnets
    security_groups = [aws_security_group.cluster-sg.id, data.aws_security_group.redis_dash.id]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.dashevents.arn
    container_name   = var.container_name4
    container_port   = var.container_port4
  }
  tags = merge(local.common_tags, {

    awsecsserviceName = "fdash-events"
  })
  propagate_tags = "SERVICE"
  # this prevents a race condition where the service can't start
  depends_on = [aws_alb_listener.https]
}

resource "aws_ecs_service" "service5" {
  name            = "auth-fg"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task5.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  network_configuration {
    subnets         = var.subnets
    security_groups = [aws_security_group.cluster-sg.id, data.aws_security_group.redis_dash.id]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.dashauth.arn
    container_name   = var.container_name5
    container_port   = var.container_port5
  }
  tags = merge(local.common_tags, {

    awsecsserviceName = "fdash-auth"
  })
  propagate_tags = "SERVICE"
  # this prevents a race condition where the service can't start
  depends_on = [aws_alb_listener.https]
}

resource "aws_ecs_service" "service6" {
  name            = "field-extraction-fg"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task6.arn
  launch_type     = "FARGATE"
  desired_count   = var.min_capacity
  network_configuration {
    subnets         = var.subnets
    security_groups = [aws_security_group.cluster-sg.id, data.aws_security_group.redis_dash.id]
  }
  tags = merge(local.common_tags, {

    awsecsserviceName = "fdash-field_extraction"
  })
  propagate_tags = "SERVICE"
}

resource "aws_ecs_service" "service7" {
  name            = "audit-fg"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task7.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  network_configuration {
    subnets         = var.subnets
    security_groups = [aws_security_group.cluster-sg.id, data.aws_security_group.redis_dash.id]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.dashaudit.arn
    container_name   = var.container_name7
    container_port   = var.container_port7
  }
  tags = merge(local.common_tags, {

    awsecsserviceName = "fdash-audit"
  })
  propagate_tags = "SERVICE"
  # this prevents a race condition where the service can't start
  depends_on = [aws_alb_listener.https]
}

resource "aws_ecs_service" "service8" {
  name            = "comparison-fg"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task8.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  network_configuration {
    subnets         = var.subnets
    security_groups = [aws_security_group.cluster-sg.id, data.aws_security_group.redis_dash.id]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.dashcomparison.arn
    container_name   = var.container_name8
    container_port   = var.container_port8
  }
  tags = merge(local.common_tags, {

    awsecsserviceName = "fdash-comparison"
  })
  propagate_tags = "SERVICE"
  # this prevents a race condition where the service can't start
  depends_on = [aws_alb_listener.https]
}

resource "aws_ecs_service" "service9" {
  name            = "integration-fg"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task9.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  network_configuration {
    subnets         = var.subnets
    security_groups = [aws_security_group.cluster-sg.id, data.aws_security_group.redis_dash.id]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.dashintegration.arn
    container_name   = var.container_name9
    container_port   = var.container_port9
  }
  tags = merge(local.common_tags, {

    awsecsserviceName = "fdash-integration"
  })
  propagate_tags = "SERVICE"
  # this prevents a race condition where the service can't start
  depends_on = [aws_alb_listener.https]
}

resource "aws_ecs_service" "service10" {
  name            = "wrapper-fg"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task10.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  network_configuration {
    subnets         = var.subnets
    security_groups = [aws_security_group.cluster-sg.id, data.aws_security_group.redis_dash.id]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.dashwrapper.arn
    container_name   = var.container_name10
    container_port   = var.container_port10
  }
  tags = merge(local.common_tags, {

    awsecsserviceName = "fdash-wrapper"
  })
  propagate_tags = "SERVICE"
  # this prevents a race condition where the service can't start
  depends_on = [aws_alb_listener.https]
}

resource "aws_ecs_service" "service11" {
  name            = "stitching-fg"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task11.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  network_configuration {
    subnets         = var.subnets
    security_groups = [aws_security_group.cluster-sg.id, data.aws_security_group.redis_dash.id]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.dashstitching.arn
    container_name   = var.container_name11
    container_port   = var.container_port11
  }
  tags = merge(local.common_tags, {

    awsecsserviceName = "fdash-stitching"
  })
  propagate_tags = "SERVICE"
  # this prevents a race condition where the service can't start
  depends_on = [aws_alb_listener.https]
}
