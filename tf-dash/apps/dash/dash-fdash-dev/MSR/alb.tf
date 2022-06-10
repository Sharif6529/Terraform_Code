resource "aws_lb_target_group" "dashextract_msr" {
  name                 = "${var.appName}-msr-${var.env}"
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

resource "aws_lb_target_group" "dashapi_msr" {
  name                 = "${var.app_name2}-msr-${var.env}"
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

resource "aws_lb_target_group" "dashevents_msr" {
  name                 = "${var.app_name4}-msr-${var.env}"
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

resource "aws_lb_target_group" "dashcomparison_msr" {
  name                 = "${var.app_name8}-msr-${var.env}"
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

resource "aws_lb_target_group" "dashintegration_msr" {
  name                 = "${var.app_name9}-msr-${var.env}"
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

resource "aws_lb_target_group" "dashwrapper_msr" {
  name                 = "${var.app_name10}-msr-${var.env}"
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

resource "aws_lb_target_group" "dashstitching_msr" {
  name                 = "${var.app_name11}-msr-${var.env}"
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

resource "aws_lb_listener_rule" "dashExtract_msr" {
  listener_arn = var.https_arn
  priority     = 91

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dashextract_msr.arn
  }

  condition {
    path_pattern {
      values = ["/extractionservice/*"]
    }
  }
}

resource "aws_lb_listener_rule" "dashapi_msr" {
  listener_arn = var.https_arn
  priority     = 96

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dashapi_msr.arn
  }

  condition {
    path_pattern {
      values = ["/apiservice/*"]
    }
  }
}

resource "aws_lb_listener_rule" "dashevents_msr" {
  listener_arn = var.https_arn
  priority     = 94

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dashevents_msr.arn
  }

  condition {
    path_pattern {
      values = ["/eventprocessingservice/*"]
    }
  }
}

resource "aws_lb_listener_rule" "dashcomparison_msr" {
  listener_arn = var.https_arn
  priority     = 98

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dashcomparison_msr.arn
  }

  condition {
    path_pattern {
      values = ["/comparisonservice/*"]
    }
  }
}

resource "aws_lb_listener_rule" "dashintegration_msr" {
  listener_arn = var.https_arn
  priority     = 89

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dashintegration_msr.arn
  }

  condition {
    path_pattern {
      values = ["/integrationservice/*"]
    }
  }
}

resource "aws_lb_listener_rule" "dashwrapper_msr" {
  listener_arn = var.https_arn
  priority     = 87

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dashwrapper_msr.arn
  }

  condition {
    path_pattern {
      values = ["/wrapperservice/*"]
    }
  }
}

resource "aws_lb_listener_rule" "dashstitching_msr" {
  listener_arn = var.https_arn
  priority     = 85

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dashstitching_msr.arn
  }

  condition {
    path_pattern {
      values = ["/stitchingservice/*"]
    }
  }
}