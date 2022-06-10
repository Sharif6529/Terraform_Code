resource "aws_lb_target_group" "dashextract_pri" {
  name                 = "${var.appName}-pri-${var.env}"
  port                 = 80
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = var.vpc_id
  deregistration_delay = 5 #shorten the drain for testing
  tags                 = var.common_tags

  health_check {
    path                = var.health_check_url_extract
    protocol            = "HTTP"
    unhealthy_threshold = 2
    healthy_threshold   = 5
  }
}

resource "aws_lb_target_group" "dashapi_pri" {
  name                 = "${var.app_name2}-pri-${var.env}"
  port                 = 80
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = var.vpc_id
  deregistration_delay = 5 #shorten the drain for testing
  tags                 = var.common_tags

  health_check {
    path                = var.health_check_url_api
    protocol            = "HTTP"
    unhealthy_threshold = 2
    healthy_threshold   = 5
  }
}

resource "aws_lb_target_group" "dashevents_pri" {
  name                 = "${var.app_name4}-pri-${var.env}"
  port                 = 80
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = var.vpc_id
  deregistration_delay = 5 #shorten the drain for testing
  tags                 = var.common_tags

  health_check {
    path                = var.health_check_url_events
    protocol            = "HTTP"
    unhealthy_threshold = 2
    healthy_threshold   = 5
  }
}

resource "aws_lb_target_group" "dashcomparison_pri" {
  name                 = "${var.app_name8}-pri-${var.env}"
  port                 = 80
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = var.vpc_id
  deregistration_delay = 5 #shorten the drain for testing
  tags                 = var.common_tags

  health_check {
    path                = var.health_check_url_comparison
    protocol            = "HTTP"
    unhealthy_threshold = 2
    healthy_threshold   = 5
  }
}

resource "aws_lb_target_group" "dashintegration_pri" {
  name                 = "${var.app_name9}-pri-${var.env}"
  port                 = 80
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = var.vpc_id
  deregistration_delay = 5 #shorten the drain for testing
  tags                 = var.common_tags

  health_check {
    path                = var.health_check_url_integration
    protocol            = "HTTP"
    unhealthy_threshold = 2
    healthy_threshold   = 5
  }
}

resource "aws_lb_target_group" "dashwrapper_pri" {
  name                 = "${var.app_name10}-pri-${var.env}"
  port                 = 80
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = var.vpc_id
  deregistration_delay = 5 #shorten the drain for testing
  tags                 = var.common_tags

  health_check {
    path                = var.health_check_url_wrapper
    protocol            = "HTTP"
    unhealthy_threshold = 2
    healthy_threshold   = 5
  }
}

resource "aws_lb_target_group" "dashstitching_pri" {
  name                 = "${var.app_name11}-pri-${var.env}"
  port                 = 80
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = var.vpc_id
  deregistration_delay = 5 #shorten the drain for testing
  tags                 = var.common_tags

  health_check {
    path                = var.health_check_url_stitching
    protocol            = "HTTP"
    unhealthy_threshold = 2
    healthy_threshold   = 5
  }
}

resource "aws_lb_listener_rule" "dashExtract_pri" {
  listener_arn = var.https_arn
  priority     = 92

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dashextract_pri.arn
  }

  condition {
    path_pattern {
      values = ["/extractionservice/*"]
    }
  }
}

resource "aws_lb_listener_rule" "dashapi_pri" {
  listener_arn = var.https_arn
  priority     = 95

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dashapi_pri.arn
  }

  condition {
    path_pattern {
      values = ["/apiservice/*"]
    }
  }
}

resource "aws_lb_listener_rule" "dashevents_pri" {
  listener_arn = var.https_arn
  priority     = 93

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dashevents_pri.arn
  }

  condition {
    path_pattern {
      values = ["/eventprocessingservice/*"]
    }
  }
}

resource "aws_lb_listener_rule" "dashcomparison_pri" {
  listener_arn = var.https_arn
  priority     = 97

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dashcomparison_pri.arn
  }

  condition {
    path_pattern {
      values = ["/comparisonservice/*"]
    }
  }
}

resource "aws_lb_listener_rule" "dashintegration_pri" {
  listener_arn = var.https_arn
  priority     = 90

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dashintegration_pri.arn
  }

  condition {
    path_pattern {
      values = ["/integrationservice/*"]
    }
  }
}

resource "aws_lb_listener_rule" "dashwrapper_pri" {
  listener_arn = var.https_arn
  priority     = 88

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dashwrapper_pri.arn
  }

  condition {
    path_pattern {
      values = ["/wrapperservice/*"]
    }
  }
}

resource "aws_lb_listener_rule" "dashstitching_pri" {
  listener_arn = var.https_arn
  priority     = 86

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dashstitching_pri.arn
  }

  condition {
    path_pattern {
      values = ["/stitchingservice/*"]
    }
  }
}
