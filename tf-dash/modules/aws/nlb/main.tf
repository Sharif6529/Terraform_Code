resource "aws_lb" "main" {
  name               = var.stack_name
  internal           =  false
  load_balancer_type = var.load_balancer_type
  #security_groups    = ["${aws_security_group.lb_sg.id}"]
  subnets            = var.subnets
}
resource "aws_lb_target_group" "tg_public_80" {
  name              = "${var.stack_name}-tg-80"
  port              = 80
  protocol          = "TCP"
  target_type       = "ip"
  vpc_id            = var.vpc_id
  proxy_protocol_v2 = false
}
resource "aws_lb" "alb" {
  name               = "${var.fullName}-lb"
  internal           = true
  load_balancer_type = "application"
  subnets            = ["subnet-2f08ec02", "subnet-0a1020d62b0136a84"]

  tags = {
    AppName = "LoanComplete"
    Environment = "POC"
  }
}
resource "aws_lb_target_group" "tg_443" {
  name     = "${var.fullName}-alb-443"
  port     = 443
  protocol = "TLS"
  target_type = "ip"
  vpc_id   = data.aws_vpc.vpc.id
}
resource "aws_lb_listener" "ln_public_80" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_public_80.arn
  }
}

resource "aws_lb_listener" "ln_public_443" {
  load_balancer_arn = aws_lb.main.arn
  port              = "443"
  protocol          = "TLS"
  ssl_policy        = "ELBSecurityPolicy-FS-2018-06"
  certificate_arn   = data.aws_acm_certificate.fmc.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_public_443.arn
  }
}
#resource "aws_security_group" "lb_sg" {
 # name        = "${var.stack_name}-lb-sg"
  #description = "Allow HTTP from Anywhere"
  #vpc_id      = var.vpc_id

  #ingress {
  #  from_port   = 80
  #  to_port     = 80
  #  protocol    = "tcp"
  #  cidr_blocks = ["0.0.0.0/0"]
  #}


  #egress {
   # from_port   = 0
   # to_port     = 65535
   # protocol    = "tcp"
   # cidr_blocks = ["0.0.0.0/0"]
  #}
#tags = {
    #Name        = "${var.stack_name}-lb-sg"
   # Environment = var.environment
 # }
#}
resource "aws_lambda_function" "static_lb_updater_80" {
  filename      = "${path.module}/populate_NLB_TG_with_ALB.zip"
  function_name = "static_lb_updater_80"
  role          = aws_iam_role.static_lb_lambda.arn
  handler       = "populate_NLB_TG_with_ALB.lambda_handler"

  source_code_hash = filebase64sha256("${path.module}/populate_NLB_TG_with_ALB.zip")

  runtime     = "python2.7"
  memory_size = 128
  timeout     = 300

  environment {
    variables = {
      ALB_DNS_NAME                      = var.alb_dns_name
      ALB_LISTENER                      = "80"
      S3_BUCKET                         = aws_s3_bucket.static_lb.id
      NLB_TG_ARN                        = aws_lb_target_group.tg_public_80.arn
      MAX_LOOKUP_PER_INVOCATION         = 50
      INVOCATIONS_BEFORE_DEREGISTRATION = 10
      CW_METRIC_FLAG_IP_COUNT           = true
    }
  }
}

resource "aws_lambda_function" "static_lb_updater_443" {
  filename      = "${path.module}/populate_NLB_TG_with_ALB.zip"
  function_name = "static_lb_updater_443"
  role          = aws_iam_role.static_lb_lambda.arn
  handler       = "populate_NLB_TG_with_ALB.lambda_handler"

  source_code_hash = filebase64sha256("${path.module}/populate_NLB_TG_with_ALB.zip")

  runtime     = "python2.7"
  memory_size = 128
  timeout     = 300

  environment {
    variables = {
      ALB_DNS_NAME                      = var.alb_dns_name
      ALB_LISTENER                      = "443"
      S3_BUCKET                         = aws_s3_bucket.static_lb.id
      NLB_TG_ARN                        = aws_lb_target_group.tg_public_443.arn
      MAX_LOOKUP_PER_INVOCATION         = 50
      INVOCATIONS_BEFORE_DEREGISTRATION = 10
      CW_METRIC_FLAG_IP_COUNT           = true
    }
  }
}

resource "aws_cloudwatch_event_rule" "cron_minute" {
  name                = "cron-minute"
  schedule_expression = "rate(1 minute)"
  is_enabled          = true
}

resource "aws_lambda_permission" "allow_cloudwatch_443" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.static_lb_updater_443.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.cron_minute.arn
}


resource "aws_cloudwatch_event_target" "static_lb_updater_80" {
  rule      = aws_cloudwatch_event_rule.cron_minute.name
  target_id = "TriggerStaticPort80"
  arn       = aws_lambda_function.static_lb_updater_80.arn
}

resource "aws_cloudwatch_event_target" "static_lb_updater_443" {
  rule      = aws_cloudwatch_event_rule.cron_minute.name
  target_id = "TriggerStaticPort443"
  arn       = aws_lambda_function.static_lb_updater_443.arn
}
resource "aws_lambda_permission" "allow_cloudwatch_80" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.static_lb_updater_80.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.cron_minute.arn
}

data "aws_elb_service_account" "main" {}
resource "aws_s3_bucket" "static_lb" {
  bucket = "${var.stack_name}-static-lb"
  acl    = "private"
  policy = <<POLICY
{
  "Id": "Policy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${var.stack_name}-static-lb/*",
      "Principal": {
        "AWS": [
          "${data.aws_elb_service_account.main.arn}"
        ]
      }
    }
  ]
}
POLICY

  versioning {
    enabled = true
  }
}


