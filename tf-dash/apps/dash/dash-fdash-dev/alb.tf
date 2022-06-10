data "aws_acm_certificate" "fhmc" {
  domain      = "*.${var.domain}"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

resource "aws_lb_target_group" "dashextract" {
  name                 = "${var.appName}-${var.env}"
  port                 = 80
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = var.vpc_id
  deregistration_delay = 5 #shorten the drain for testing
  tags                 = local.common_tags

  health_check {
    path                = var.health_check_url_extract
    protocol            = "HTTP"
    unhealthy_threshold = 2
    healthy_threshold   = 5
  }
}

resource "aws_lb_target_group" "dashui" {
  name                 = "${var.app_name}-${var.env}"
  port                 = 80
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = var.vpc_id
  deregistration_delay = 5 #shorten the drain for testing
  tags                 = local.common_tags

  health_check {
    path                = var.health_check_url_ui
    protocol            = "HTTP"
    unhealthy_threshold = 2
    healthy_threshold   = 5
  }
}

resource "aws_lb_target_group" "dashapi" {
  name                 = "${var.app_name2}-${var.env}"
  port                 = 80
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = var.vpc_id
  deregistration_delay = 5 #shorten the drain for testing
  tags                 = local.common_tags

  health_check {
    path                = var.health_check_url_api
    protocol            = "HTTP"
    unhealthy_threshold = 2
    healthy_threshold   = 5
  }
}


# resource "aws_lb_target_group" "dashclassify" {
#   name                 = "${var.app_name3}-${var.env}"
#   port                 = 80
#   protocol             = "HTTP"
#   target_type          = "ip"
#   vpc_id               = var.vpc_id
#   deregistration_delay = 5 #shorten the drain for testing
#   tags                 = local.common_tags

#   health_check {
#     path                = var.health_check_url_classify
#     protocol            = "HTTP"
#     unhealthy_threshold = 2
#     healthy_threshold   = 5
#   }
# }

resource "aws_lb_target_group" "dashevents" {
  name                 = "${var.app_name4}-${var.env}"
  port                 = 80
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = var.vpc_id
  deregistration_delay = 5 #shorten the drain for testing
  tags                 = local.common_tags

  health_check {
    path                = var.health_check_url_events
    protocol            = "HTTP"
    unhealthy_threshold = 2
    healthy_threshold   = 5
  }
}


resource "aws_lb_target_group" "dashauth" {
  name                 = "${var.app_name5}-${var.env}"
  port                 = 80
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = var.vpc_id
  deregistration_delay = 5 #shorten the drain for testing
  tags                 = local.common_tags

  health_check {
    path                = var.health_check_url_auth
    protocol            = "HTTP"
    unhealthy_threshold = 2
    healthy_threshold   = 5
  }
}


# resource "aws_lb_target_group" "dashfield" {
#   name                 = "${var.app_name6}-${var.env}"
#   port                 = 80
#   protocol             = "HTTP"
#   target_type          = "ip"
#   vpc_id               = var.vpc_id
#   deregistration_delay = 5 #shorten the drain for testing
#   tags                 = local.common_tags

#   health_check {
#     path                = var.health_check_url_field_extraction
#     protocol            = "HTTP"
#     unhealthy_threshold = 2
#     healthy_threshold   = 5
#   }
# }


resource "aws_lb_target_group" "dashaudit" {
  name                 = "${var.app_name7}-${var.env}"
  port                 = 80
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = var.vpc_id
  deregistration_delay = 5 #shorten the drain for testing
  tags                 = local.common_tags

  health_check {
    path                = var.health_check_url_audit
    protocol            = "HTTP"
    unhealthy_threshold = 2
    healthy_threshold   = 5
  }
}


resource "aws_lb_target_group" "dashcomparison" {
  name                 = "${var.app_name8}-${var.env}"
  port                 = 80
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = var.vpc_id
  deregistration_delay = 5 #shorten the drain for testing
  tags                 = local.common_tags

  health_check {
    path                = var.health_check_url_comparison
    protocol            = "HTTP"
    unhealthy_threshold = 2
    healthy_threshold   = 5
  }
}

resource "aws_lb_target_group" "dashintegration" {
  name                 = "${var.app_name9}-${var.env}"
  port                 = 80
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = var.vpc_id
  deregistration_delay = 5 #shorten the drain for testing
  tags                 = local.common_tags

  health_check {
    path                = var.health_check_url_integration
    protocol            = "HTTP"
    unhealthy_threshold = 2
    healthy_threshold   = 5
  }
}


resource "aws_lb_target_group" "dashwrapper" {
  name                 = "${var.app_name10}-${var.env}"
  port                 = 80
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = var.vpc_id
  deregistration_delay = 5 #shorten the drain for testing
  tags                 = local.common_tags

  health_check {
    path                = var.health_check_url_wrapper
    protocol            = "HTTP"
    unhealthy_threshold = 2
    healthy_threshold   = 5
  }
}

resource "aws_lb_target_group" "dashstitching" {
  name                 = "${var.app_name11}-${var.env}"
  port                 = 80
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = var.vpc_id
  deregistration_delay = 5 #shorten the drain for testing
  tags                 = local.common_tags

  health_check {
    path                = var.health_check_url_stitching
    protocol            = "HTTP"
    unhealthy_threshold = 2
    healthy_threshold   = 5
  }
}

resource "aws_lb" "dashUI" {
  name               = "${var.app}-${var.env}"
  load_balancer_type = "application"
  internal           = true
  security_groups    = [aws_security_group.web.id]
  subnets            = var.subnets
  idle_timeout       = 300
  tags               = local.common_tags

  access_logs {
    bucket  = var.albLogBucket
    prefix  = "${var.app}-${var.env}"
    enabled = true
  }
}

resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_lb.dashUI.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = data.aws_acm_certificate.fhmc.arn
  ssl_policy        = var.ssl_policy

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "application/json"
      message_body = "{ \"errorMessage\": \"Invalid path or context.\" }"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "dashUI" {
  listener_arn = aws_alb_listener.https.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dashextract.arn
  }

  condition {
    path_pattern {
      values = ["/extractionservice/*"]
    }
  }
}


resource "aws_lb_listener_rule" "dashUI1" {
  listener_arn = aws_alb_listener.https.arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dashui.arn
  }

  condition {
    path_pattern {
      values = ["/dashui/*"]
    }
  }
}

resource "aws_lb_listener_rule" "dashapi" {
  listener_arn = aws_alb_listener.https.arn
  priority     = 2

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dashapi.arn
  }

  condition {
    path_pattern {
      values = ["/apiservice/*"]
    }
  }
}


# resource "aws_lb_listener_rule" "dashclassify" {
#   listener_arn = aws_alb_listener.https.arn
#   priority     = 96

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.dashclassify.arn
#   }

#   condition {
#     path_pattern {
#       values = ["/*"]
#     }
#   }
# }

resource "aws_lb_listener_rule" "dashevents" {
  listener_arn = aws_alb_listener.https.arn
  priority     = 3

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dashevents.arn
  }

  condition {
    path_pattern {
      values = ["/eventprocessingservice/*"]
    }
  }
}


resource "aws_lb_listener_rule" "dashui" {
  listener_arn = aws_alb_listener.https.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dashui.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

resource "aws_lb_listener_rule" "dashauth" {
  listener_arn = aws_alb_listener.https.arn
  priority     = 5

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dashauth.arn
  }

  condition {
    path_pattern {
      values = ["/authservice/*"]
    }
  }
}

# resource "aws_lb_listener_rule" "dashfield" {
#   listener_arn = aws_alb_listener.https.arn
#   priority     = 92

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.dashfield.arn
#   }

#   condition {
#     path_pattern {
#       values = ["/tesseract-service/*"]
#     }
#   }
# }

resource "aws_lb_listener_rule" "dashaudit" {
  listener_arn = aws_alb_listener.https.arn
  priority     = 6

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dashaudit.arn
  }

  condition {
    path_pattern {
      values = ["/auditservice/*"]
    }
  }
}

resource "aws_lb_listener_rule" "dashcomparison" {
  listener_arn = aws_alb_listener.https.arn
  priority     = 7

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dashcomparison.arn
  }

  condition {
    path_pattern {
      values = ["/comparisonservice/*"]
    }
  }
}

resource "aws_lb_listener_rule" "dashintegration" {
  listener_arn = aws_alb_listener.https.arn
  priority     = 8

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dashintegration.arn
  }

  condition {
    path_pattern {
      values = ["/integrationservice/*"]
    }
  }
}

resource "aws_lb_listener_rule" "dashwrapper" {
  listener_arn = aws_alb_listener.https.arn
  priority     = 9

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dashwrapper.arn
  }

  condition {
    path_pattern {
      values = ["/wrapperservice/*"]
    }
  }
}

resource "aws_lb_listener_rule" "dashstitching" {
  listener_arn = aws_alb_listener.https.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dashstitching.arn
  }

  condition {
    path_pattern {
      values = ["/stitchingservice/*"]
    }
  }
}
