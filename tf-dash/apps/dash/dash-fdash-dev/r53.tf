data "aws_route53_zone" "fhmc" {
  name         = var.domain
  private_zone = true
}
resource "aws_route53_record" "fhmc" {
  zone_id = data.aws_route53_zone.fhmc.zone_id
  name    = "${var.appName}-${var.env}.${var.domain}"
  type    = "A"

  alias {
    name                   = aws_lb.dashUI.dns_name
    zone_id                = aws_lb.dashUI.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "fhmc1" {
  zone_id = data.aws_route53_zone.fhmc.zone_id
  name    = "${var.app_name}-${var.env}.${var.domain}"
  type    = "A"

  alias {
    name                   = aws_lb.dashUI.dns_name
    zone_id                = aws_lb.dashUI.zone_id
    evaluate_target_health = true
  }
}

# resource "aws_route53_record" "compute" {
#   count   = var.ec2_count
#   zone_id = data.aws_route53_zone.fhmc.zone_id
#   name    = "${var.ec2_name_prefix}-${var.env}${format("%02g", count.index + 1)}.${data.aws_route53_zone.fhmc.name}"
#   type    = "A"
#   records = split(",", aws_instance.this[count.index].private_ip)
#   ttl     = 300
# }
