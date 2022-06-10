resource "aws_lb_target_group_attachment" "ip" {
  target_group_arn = var.tg_arn
  target_id        = var.ip
  port             = var.port
  availability_zone = "all"
}