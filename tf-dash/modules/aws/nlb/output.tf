output "this_lb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = concat(aws_lb.main.*.dns_name, [""])[0]
}

output "s3_log_bucket" {
  value       = aws_s3_bucket.static_lb.id
}