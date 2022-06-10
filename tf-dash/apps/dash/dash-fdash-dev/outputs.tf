#Add required outputs 
#output "alb_domainextract" { value = "[aws_route53_record.fhmc.*.name]${var.health_check_url}" }
output "alb_domainextract" { value = [aws_route53_record.fhmc.name] }
output "alb_domainfg" { value = [aws_route53_record.fhmc1.name] }
# output "ecs_host_ip" { value = [aws_instance.this.*.private_ip] }
# output "ecs_subnets" { value = [aws_instance.this.*.subnet_id] }
