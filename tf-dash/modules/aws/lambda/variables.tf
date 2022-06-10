##Lambda Variables
variable "filename" {}
variable "name" {
  type = string
  default = ""
}
variable "tracing_mode" {
  description = "Tracing mode of the Lambda Function. Valid value can be either PassThrough or Active."
  type        = string
  default     = null
}

variable "handler" {}
variable "runtime" {}
variable "role_arn" {}

variable "environment_variables" {
  description = "A map that defines environment variables for the Lambda Function."
  type        = map(string)
  default     = {}
}


variable "create" {
  description = "Controls whether resources should be created"
  type        = bool
  default     = false
}
variable "create_lifecycle" {
  description = "Controls whether resources should be created"
  type        = bool
  default     = false
}
variable "create_function" {
  description = "Controls whether resources should be created"
  type        = bool
  default     = true
}
variable "create_layer" {
  description = "Controls whether Lambda Layer resource should be created"
  type        = bool
  default     = false
}
variable "create_async_event_config" {
  description = "Controls whether async event configuration for Lambda Function/Alias should be created"
  type        = bool
  default     = false
}
variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime. Valid value between 128 MB to 3008 MB, in 64 MB increments."
  type        = number
  default     = 128
}
variable "timeout" {
  description = "The amount of time your Lambda Function has to run in seconds."
  type        = number
  default     = 3
}
variable "dead_letter_target_arn" {
  description = "The ARN of an SNS topic or SQS queue to notify when an invocation fails."
  type        = string
  default     = null
}
variable "vpc_subnet_ids" {
  description = "List of subnet ids when Lambda Function should run in the VPC. Usually private or intra subnets."
  type        = list(string)
  default     = null
}

variable "vpc_security_group_ids" {
  description = "List of security group ids when Lambda Function should run in the VPC."
  type        = list(string)
  default     = null
}
variable "destination_on_failure" {
  description = "Amazon Resource Name (ARN) of the destination resource for failed asynchronous invocations"
  type        = string
  default     = null
}
variable "destination_on_success" {
  description = "Amazon Resource Name (ARN) of the destination resource for successful asynchronous invocations"
  type        = string
  default     = null
}
variable "event_source_mapping" {
  description = "Map of event source mapping"
  type        = any
  default     = {} 
}
variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}
variable "description" {
  type = string
  default = ""
}
variable "allowed_triggers" {
  description = "Map of allowed triggers to create Lambda permissions"
  type        = map(any)
  default     = {}
}