variable "vpc_id" {
  type = string
}



variable "alb_dns_name" {
  type = string
}


variable "stack_name" {
  type        = string
 
}
variable "load_balancer_type" {
  type        = string
}

variable "tags" {
  type        = map(string)
}
variable "environment" {}

variable "subnets" {
  type        = list(string)
  default     = []
}