resource "aws_security_group" "alb_sg" {
  name        = "${var.stack_name}-alb-sg"
  description = "Allow HTTP from Anywhere"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
tags = {
    Name        = "${var.stack_name}-alb-sg"
    Environment = var.environment
  }
}
resource "aws_lb" "this" {
  name               = "${var.stack_name}-alb"
  load_balancer_type = var.load_balancer_type
  internal           = var.internal
  security_groups    = ["${aws_security_group.alb_sg.id}"]
  subnets            = var.subnets

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.front_end.arn}"
  }
}

resource "aws_alb_listener" "alb_listener_http" {  
  load_balancer_arn = aws_lb.this.arn  
  port              = 80 
  protocol          = "HTTP"
  
  default_action {    
    target_group_arn = "${aws_lb_target_group.alb_tg.arn}"
    type             = "forward"  
  }
}

#resource "aws_lb_listener" "alb_listener_https" {
  #load_balancer_arn = aws_lb.this.arn
  #port              = "443"
  #protocol          = "HTTPS"

  #default_action {
  #  type             = "forward"
    #target_group_arn = "${aws_lb_target_group.alb_tg.arn}"
  #}
#}

output "this_lb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = concat(aws_lb.this.*.dns_name, [""])[0]
}
