provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_instance_profile" "profile" {
  name = "${var.fullName}-${var.env}"
  role = aws_iam_role.role.name
}
resource "aws_iam_role" "role" {
  name = "${var.fullName}-${var.env}"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}
