resource "aws_security_group" "web" {
  name        = "${var.app}-web-${var.env}-sg"
  description = "For the ECSdash2 ALB"
  vpc_id      = var.vpc_id
  tags        = local.common_tags

  ingress {
    description = "Only accepting secure traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.cidr_list
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_security_group" "cluster-sg" {
  name        = "${var.app}-cluster-${var.env}-sg"
  description = "For the ECSdash2 EC2 and ECS instances"
  vpc_id      = var.vpc_id
  tags        = local.common_tags

  ingress {
    description = "Access to the host machine"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.cidr_list
  }
  ingress {
    description     = "Just accept traffic from the ALB"
    from_port       = 8000
    to_port         = 8100
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }
  ingress {
    description     = "Just accept traffic from the ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "ui" {
  name        = "${var.app}-ui-${var.env}-sg"
  description = "For the ECSdash2 EC2 and ECS instances"
  vpc_id      = var.vpc_id
  tags        = local.common_tags

  ingress {
    description = "Access to the host machine"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.cidr_list
  }
  ingress {
    description     = "Just accept traffic from the ALB"
    from_port       = 9085
    to_port         = 9085
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }
  ingress {
    description     = "Just accept traffic from the ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
}

data "aws_security_group" "redis_dash" {
  id = var.redis_dash
}
