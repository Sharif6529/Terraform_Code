
variable "env" { type = string }
variable "autoscaling_group_msr" { type = string }
variable "cluster-sg" { type = string }
variable "https_arn" { type = string }
variable "redis-sg" { type = string }
variable "common_tags" { type = map(any) }
variable "https" {
  type = any
}

variable "container_name_extract_msr" {
  type    = string
  default = "fdash-extract-msr"
}
variable "container_name_event_msr" {
  type    = string
  default = "fdash-event-msr"
}
variable "container_name_field_msr" {
  type    = string
  default = "fdash-field-msr"
}
variable "container_name_classify_msr" {
  type    = string
  default = "fdash-classify-msr"
}
variable "container_name_api_msr" {
  type    = string
  default = "fdash-api-msr"
}
variable "container_name_comparison_msr" {
  type    = string
  default = "fdash-comparison-msr"
}
variable "container_name_integration_msr" {
  type    = string
  default = "fdash-integration-msr"
}
variable "container_name_wrapper_msr" {
  type    = string
  default = "fdash-wrapper-msr"
}
variable "container_name_stitching_msr" {
  type    = string
  default = "fdash-stitching-msr"
}

variable "java_secret_msr" {
  type        = string
  description = "Secret Env variable for Java services"
  default     = null
}

variable "app" {
  type    = string
  default = "FDASH"
}
variable "appName" {
  type    = string
  default = "fdash-extraction"
}
variable "app_name" {
  type    = string
  default = "fdash-dash-ui"
}
variable "app_name2" {
  type    = string
  default = "fdash-api-service"
}
variable "app_name3" {
  type    = string
  default = "fdash-classification"
}
variable "app_name4" {
  type    = string
  default = "fdash-event-service"
}
variable "app_name5" {
  type    = string
  default = "fdash-auth-service"
}

variable "app_name6" {
  type    = string
  default = "fdash-field-service"
}
variable "app_name7" {
  type    = string
  default = "fdash-audit-service"
}
variable "app_name8" {
  type    = string
  default = "fdash-compare-service"
}
variable "app_name9" {
  type    = string
  default = "fdash-integrate-service"
}
variable "app_name10" {
  type    = string
  default = "fdash-wrapper-service"
}
variable "app_name11" {
  type    = string
  default = "fdash-stitching-service"
}

# Networking
# variable "domain" { type = string }
variable "vpc_id" { type = string }
variable "subnets" { type = list(string) }
# variable "cidr_list" { type = list(string) }
variable "redis_dash" { type = string }

# Container
variable "extractioncontainer_cpu" { type = number }
variable "extractioncontainer_memory" { type = number }
variable "pythoncontainer_cpu" { type = number }
variable "pythoncontainer_memory" { type = number }
variable "container_cpu" { type = number }
variable "container_memory" { type = number }

variable "container_name" {
  type    = string
  default = "fdash-extract"
}
variable "container_name1" {
  type    = string
  default = "fdash-ui"
}
variable "container_name2" {
  type    = string
  default = "fdash-api"
}
variable "container_name3" {
  type    = string
  default = "fdash-classify"
}
variable "container_name4" {
  type    = string
  default = "fdash-events"
}
variable "container_name5" {
  type    = string
  default = "fdash-auth"
}
variable "container_name6" {
  type    = string
  default = "fdash-field-extract"
}
variable "container_name7" {
  type    = string
  default = "fdash-audit"
}
variable "container_name8" {
  type    = string
  default = "fdash-comparison"
}
variable "container_name9" {
  type    = string
  default = "fdash-integration"
}
variable "container_name10" {
  type    = string
  default = "fdash-wrapper"
}
variable "container_name11" {
  type    = string
  default = "fdash-stitching"
}

variable "container_image" {
  type    = string
  default = ""
}
variable "container_image1" {
  type    = string
  default = ""
}
variable "container_image2" {
  type    = string
  default = ""
}
variable "container_image3" {
  type    = string
  default = ""
}
variable "container_image4" {
  type    = string
  default = ""
}
variable "container_image5" {
  type    = string
  default = ""
}
variable "container_image6" {
  type    = string
  default = ""
}
variable "container_image7" {
  type    = string
  default = ""
}
variable "container_image8" {
  type    = string
  default = ""
}
variable "container_image9" {
  type    = string
  default = ""
}
variable "container_image10" {
  type    = string
  default = ""
}
variable "container_image11" {
  type    = string
  default = ""
}

variable "container_port" {
  type    = number
  default = 8088
}
variable "container_port1" {
  type    = number
  default = 80
}
variable "container_port2" {
  type    = number
  default = 8085
}
variable "container_port3" {
  type    = number
  default = 8088
}
variable "container_port4" {
  type    = number
  default = 8086
}
variable "container_port5" {
  type    = number
  default = 8087
}
variable "container_port6" {
  type    = number
  default = 8088
}
variable "container_port7" {
  type    = number
  default = 8089
}
variable "container_port8" {
  type    = number
  default = 8092
}
variable "container_port9" {
  type    = number
  default = 8091
}
variable "container_port10" {
  type    = number
  default = 8093
}
variable "container_port11" {
  type    = number
  default = 8094
}

variable "fdash-extraction-image" {
  type    = string
  default = "latest"
}
variable "fdash-dash-ui-image" {
  type    = string
  default = "latest"
}
variable "fdash-api-service-image" {
  type    = string
  default = "latest"
}
variable "fdash-classification-image" {
  type    = string
  default = "latest"
}
variable "fdash-event-service-image" {
  type    = string
  default = "latest"
}
variable "fdash-auth-service-image" {
  type    = string
  default = "latest"
}
variable "fdash-field-service-image" {
  type    = string
  default = "latest"
}
variable "fdash-audit-service-image" {
  type    = string
  default = "latest"
}
variable "fdash-comparison-service-image" {
  type    = string
  default = "latest"
}
variable "fdash-integration-service-image" {
  type    = string
  default = "latest"
}
variable "fdash-wrapper-service-image" {
  type    = string
  default = "latest"
}
variable "fdash-stitching-service-image" {
  type    = string
  default = "latest"
}

variable "ecs_task_execution_role_arn" { type = string }

variable "host_port" {
  type    = number
  default = 8088
}
variable "host_port1" {
  type    = number
  default = 80
}
variable "host_port2" {
  type    = number
  default = 8085
}
variable "host_port3" {
  type    = number
  default = 8088
}
variable "host_port4" {
  type    = number
  default = 8086
}
variable "host_port5" {
  type    = number
  default = 8087
}
variable "host_port6" {
  type    = number
  default = 8088
}
variable "host_port7" {
  type    = number
  default = 8089
}
variable "host_port8" {
  type    = number
  default = 8092
}
variable "host_port9" {
  type    = number
  default = 8091
}
variable "host_port10" {
  type    = number
  default = 8093
}
variable "host_port11" {
  type    = number
  default = 8094
}

variable "log_configuration_api_new" {
  type    = string
  default = ""
}
variable "log_configuration_auth_new" {
  type    = string
  default = ""
}
variable "log_configuration_events_new" {
  type    = string
  default = ""
}
variable "log_configuration_ui_new" {
  type    = string
  default = ""
}
variable "log_configuration_classify_new" {
  type    = string
  default = ""
}
variable "log_configuration_field_new" {
  type    = string
  default = ""
}
variable "log_configuration_audit_new" {
  type    = string
  default = ""
}
variable "log_configuration_comparison_new" {
  type    = string
  default = ""
}
variable "log_configuration_integration_new" {
  type    = string
  default = ""
}
variable "log_configuration_wrapper_new" {
  type    = string
  default = ""
}
variable "log_configuration_stitching_new" {
  type    = string
  default = ""
}
variable "log_configuration_extract_new" {
  type    = string
  default = ""
}

variable "log_groups_msr" {
  type        = list(string)
  description = "Log groups that will be created in CloudWatch logs for MSR"
  default     = []
}

variable "service_name_msr" {
  type        = list(string)
  description = "Python Service Name list for the ECS cluster"
  default = ["classify-fg", "events-fg", "field-extraction-fg", "extract-ec2",
  "comparison-fg", "integration-fg", "wrapper-fg", "stitching-fg", "api-fg"]
}

# Auto Scaling
variable "min_capacity" { type = number }
variable "max_capacity" { type = number }
variable "cpu_target_value" { type = number }
variable "memory_target_value" { type = number }

# oneagent Agent Container
variable "oneag_container_name" {
  type    = string
  default = "OneAgentInit"
}
variable "oneag_container_image" {
  type    = string
  default = "996190702173.dkr.ecr.us-east-1.amazonaws.com/alpineimage_dev"
}
variable "oneag_container_image_version" {
  type    = string
  default = "3"
}
variable "oneag_command" {
  type    = string
  default = "ARCHIVE=$(mktemp) && wget -O "
}
variable "oneag_api_url" {
  type    = string
  default = "https://mvd33521.live.dynatrace.com/api"
}
variable "oneag_options" {
  type    = string
  default = "flavor=default&include=all"
}
variable "oneag_pass_token" {
  type    = string
  default = ""
}

variable "oneag_entrypoint" {
  type        = list(string)
  description = "EntryPoint for OneAgent"
  default     = ["/bin/sh", "-c"]
}

variable "ld_preload_cmd" { type = string }
variable "oneag_taskvol" {
  type    = string
  default = "oneAgentVol"
}
variable "oneag_container_path" {
  type    = string
  default = "/opt/dynatrace/oneagent"
}
variable "volumes" {
  description = "(Optional) A set of volume blocks that containers in your task may use"
  type = list(object({
    host_path = string
    name      = string
  }))
}
variable "mount_points" {
  type        = list(any)
  description = "Container mount points. This is a list of maps, where each map should contain a `containerPath` and `sourceVolume`. The `readOnly` key is optional."
  default     = []
}

variable "health_check_url_extract" {
  type    = string
  default = "/extractionservice/actuator"
}
variable "health_check_url_events" {
  type    = string
  default = "/eventprocessingservice/actuator"
}
variable "health_check_url_ui" {
  type    = string
  default = "/"
}
variable "health_check_url_api" {
  type    = string
  default = "/apiservice/actuator"
}
variable "health_check_url_auth" {
  type    = string
  default = "/authservice/actuator"
}
variable "health_check_url_classify" {
  type    = string
  default = "/extractionservice/actuator"
}
variable "health_check_url_field_extraction" {
  type    = string
  default = "/extractionservice/actuator"
}
variable "health_check_url_audit" {
  type    = string
  default = "/auditservice/actuator"
}
variable "health_check_url_comparison" {
  type    = string
  default = "/comparisonservice/actuator"
}
variable "health_check_url_integration" {
  type    = string
  default = "/integrationservice/actuator"
}
variable "health_check_url_wrapper" {
  type    = string
  default = "/wrapperservice/actuator"
}
variable "health_check_url_stitching" {
  type    = string
  default = "/stitchingservice/actuator"
}
