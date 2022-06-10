variable "name" {}

variable "tg_arn_suffix" {}
variable "alarm_name" {}
variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`"
}
variable "low_evaluation_periods" {
  type        = string
  description = "The number of periods over which data is compared to the low threshold"
  default     = "2"
}
variable "low_threshold" {
  type        = string
  description = "The value against which the low statistic is compared"
  default     = "5"
}
/*variable "target_value" {
  description = "Requests per target in target group metrics to trigger scaling activity"
  type        = number
}*/
variable "scale_in_cooldown" {
  description = "Time between scale in action"
  default     = 300
  type        = number
}
variable "scale_out_cooldown" {
  description = "Time between scale out action"
  default     = 300
  type        = number
}
variable "alb_arn_suffix" {
  description = "ARN Suffix (not full ARN) of the Application Load Balancer for use with CloudWatch. Output attribute from LB resource: `arn_suffix`"
  type        = string
}

variable "metric_query" {
  description = "Enables you to create an alarm based on a metric math expression. You may specify at most 20."
  type        = any
  default     = []
}
variable "high_evaluation_periods" {
  type        = string
  description = "The number of periods over which data is compared to the high threshold"
  default     = "2"
}
variable "high_threshold" {
  type        = string
  description = "The value against which the high statistic is compared"
  default     = "-1"
}
variable "enabled" {
    type = bool
    default = true
}
variable "step_enabled" {
    type = bool
    default = true
}
variable "targetracking_enabled" {
    type = bool
    default = false
}
variable "min_capacity" {
  type        = number
  description = "Minimum number of running instances of a Service"
  default     = 1
}

variable "max_capacity" {
  type        = number
  description = "Maximum number of running instances of a Service"
  default     = 2
}

variable "cluster_name" {
  type        = string
  description = "The name of the ECS cluster where service is to be autoscaled"
}

variable "service_name" {
  type        = string
  description = "The name of the ECS Service to autoscale"
}

variable "scale_up_adjustment" {
  type        = number
  description = "Scaling adjustment to make during scale up event"
  default     = 1
}

variable "scale_up_cooldown" {
  type        = number
  description = "Period (in seconds) to wait between scale up events"
  default     = 60
}

variable "scale_down_adjustment" {
  type        = number
  description = "Scaling adjustment to make during scale down event"
  default     = -1
}

variable "scale_down_cooldown" {
  type        = number
  description = "Period (in seconds) to wait between scale down events"
  default     = 300
}