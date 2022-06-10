# aws_profile = "Dash_Developer_Terraform-996190702173"
aws_region = "us-east-1"
env        = "dev"
app        = "FDASH"
# appName    = "fdash-extraction"
# app_name   = "fdash-dash-ui"
# app_name2  = "fdash-api-service"
# app_name3  = "fdash-classification"
# app_name4  = "fdash-event-service"
# app_name5  = "fdash-auth-service"
# app_name6  = "fdash-field-service"
# app_name7  = "fdash-audit-service"
# app_name8  = "fdash-comparison-service"
# app_name9  = "fdash-integrate-service"
# app_name10 = "fdash-wrapper-service"
# app_name11 = "fdash-stitching-service"


# Networking
domain     = "fhmcdev.cloud"
vpc_id     = "vpc-113d0d75"
subnets    = ["subnet-0d4ed851a151f9a57", "subnet-0e0437eb43920617c"]
cidr_list  = ["10.0.0.0/8"]
redis_dash = "sg-0abffc49c769b6e1f"

# EC2
ec2_count       = 2
ec2_name_prefix = "fdashextlx"
ec2_ami         = "ami-0fab23c65778d8fe0"
# ec2_ami = "ami-0fab23c65778d8fe0"
# instance_type = "t3.large"
instance_type = "c5.xlarge"
ec2_subnet    = "subnet-0d4ed851a151f9a57"
#ec2_profile = "ecsInstanceRole"
ec2_profile                 = "ecsDashInstanceRole"
ecs_task_execution_role_arn = "arn:aws:iam::996190702173:role/ecsDashTaskExecutionRole"
ec2_key                     = "" # this is disabled in the AMI.
ec2_cpu_credits             = "standard"
ebs_type                    = "gp3"
ebs_size                    = 30
ebs_kms_id                  = "arn:aws:kms:us-east-1:996190702173:key/6668d08d-0fbd-4496-8a5a-1b0e56613776"

# ALB
albLogBucket = "fhmc-dev-logs"
# health_check_url_events           = "/eventprocessingservice/actuator"
# health_check_url_api              = "/apiservice/actuator"
# health_check_url_ui               = "/"
# health_check_url_auth             = "/authservice/actuator"
# health_check_url_classify         = "/extractionservice/actuator"
# health_check_url_extract          = "/extractionservice/actuator"
# health_check_url_field_extraction = "/extractionservice/actuator"
# health_check_url_audit            = "/auditservice/actuator"
# health_check_url_comparison       = "/comparisonservice/actuator"
# health_check_url_integration      = "/integrationservice/actuator"
# health_check_url_wrapper          = "/wrapperservice/actuator"
# health_check_url_stitching        = "/stitchingservice/actuator"
ssl_policy = "ELBSecurityPolicy-FS-1-2-2019-08"

# Environment Variables

# Container
# container_name  = "fdash-extract"
# container_name1 = "fdash-ui"
# container_name2 = "fdash-api"
# container_name3 = "fdash-classify"
# container_name4 = "fdash-events"
# container_name5 = "fdash-auth"

# container_name6  = "fdash-field-extract"
# container_name7  = "fdash-audit"
# container_name8  = "fdash-comparison"
# container_name9  = "fdash-integration"
# container_name10 = "fdash-wrapper"
# container_name11 = "fdash-stitching"


container_image   = "996190702173.dkr.ecr.us-east-1.amazonaws.com/fdash-extraction-service-dev"
container_image1  = "996190702173.dkr.ecr.us-east-1.amazonaws.com/fdash-dash-ui-dev"
container_image2  = "996190702173.dkr.ecr.us-east-1.amazonaws.com/fdash-api-service-dev"
container_image3  = "996190702173.dkr.ecr.us-east-1.amazonaws.com/fdash-classification-service-dev"
container_image4  = "996190702173.dkr.ecr.us-east-1.amazonaws.com/fdash-event-processing-service-dev"
container_image5  = "996190702173.dkr.ecr.us-east-1.amazonaws.com/fdash-auth-service-dev"
container_image6  = "996190702173.dkr.ecr.us-east-1.amazonaws.com/fdash-field-extraction-service-dev"
container_image7  = "996190702173.dkr.ecr.us-east-1.amazonaws.com/fdash-audit-log-service-dev"
container_image8  = "996190702173.dkr.ecr.us-east-1.amazonaws.com/fdash-comparison-service-dev"
container_image9  = "996190702173.dkr.ecr.us-east-1.amazonaws.com/fdash-integration-service-dev"
container_image10 = "996190702173.dkr.ecr.us-east-1.amazonaws.com/fdash-wrapper-service-dev"
container_image11 = "996190702173.dkr.ecr.us-east-1.amazonaws.com/fdash-stitching-service-dev"

container_cpu              = "1024" # 1 vCPU
container_memory           = "4096" # 2GB ram
extractioncontainer_cpu    = "4096"
extractioncontainer_memory = "7500"
pythoncontainer_cpu        = "2048"
pythoncontainer_memory     = "5120"

# container_port   = 8088
# container_port1  = 80
# container_port2  = 8085
# container_port3  = 8088
# container_port4  = 8086
# container_port5  = 8087
# container_port6  = 8088
# container_port7  = 8089
# container_port8  = 8092
# container_port9  = 8091
# container_port10 = 8093
# container_port11 = 8094
# host_port        = 8088
# host_port1       = 80
# host_port2       = 8085
# host_port3       = 8020
# host_port4       = 8086
# host_port5       = 8087
# host_port6       = 8020
# host_port7       = 8089
# host_port8       = 8092
# host_port9       = 8091
# host_port10      = 8093
# host_port11      = 8094

desireCount = 1
volumes = [
  { name = "docs", host_path = "/docs" },
  { name = "oneAgentVol", host_path = "" },
]
mount_points = [
  { "sourceVolume" : "docs", "containerPath" : "/docs", "readOnly" : false },
]

log_groups = [
  "ecs-api-dev", "ecs-event-dev", "ecs-classify-dev", "ecs-auth-dev", "ecs-ui-dev", "ecs-extract-dev",
  "ecs-field-dev", "ecs-audit-dev", "ecs-comparison-dev", "ecs-integration-dev", "ecs-wrapper-dev", "ecs-stitching-dev"
]

log_groups_pri = [
  "ecs-event-dev-pri", "ecs-classify-dev-pri", "ecs-extract-dev-pri", "ecs-field-dev-pri",
  "ecs-api-dev-pri", "ecs-comparison-dev-pri", "ecs-integration-dev-pri", "ecs-wrapper-dev-pri", "ecs-stitching-dev-pri"
]

log_groups_msr = [
  "ecs-event-dev-msr", "ecs-classify-dev-msr", "ecs-extract-dev-msr", "ecs-field-dev-msr",
  "ecs-api-dev-msr", "ecs-comparison-dev-msr", "ecs-integration-dev-msr", "ecs-wrapper-dev-msr", "ecs-stitching-dev-msr"
]

service_name = [
  "extract-ec2", "ui-fg", "api-fg", "classify-fg", "events-fg", "auth-fg", "field-extraction-fg",
  "audit-fg", "comparison-fg", "integration-fg", "wrapper-fg", "stitching-fg"
]
service_name_java = [
  "extract-ec2", "ui-fg", "api-fg", "auth-fg", "stitching-fg",
  "audit-fg", "comparison-fg", "integration-fg", "wrapper-fg"
]
service_name_python = [
  "classify-fg", "events-fg", "field-extraction-fg"
]
sqs_names = ["fdash-page-classification-req-dev", "fdash-page-field-extraction-req-dev"]

log_configuration_api_new         = "/ecs-api-dev"
log_configuration_events_new      = "/ecs-event-dev"
log_configuration_classify_new    = "/ecs-classify-dev"
log_configuration_ui_new          = "/ecs-ui-dev"
log_configuration_auth_new        = "/ecs-auth-dev"
log_configuration_field_new       = "/ecs-field-dev"
log_configuration_audit_new       = "/ecs-audit-dev"
log_configuration_comparison_new  = "/ecs-comparison-dev"
log_configuration_integration_new = "/ecs-integration-dev"
log_configuration_wrapper_new     = "/ecs-wrapper-dev"
log_configuration_stitching_new   = "/ecs-stitching-dev"
log_configuration_extract_new     = "/ecs-extract-dev"

# Env Variable 

java_secret     = "-Dfreedom.app.name=fdash -Dfreedom.environment=dev -Dspring.profiles.active=dev -Dcloud.aws.region.static=us-east-1 -Dcloud.aws.region.auto=false"
java_secret_msr = "-Dfreedom.app.name=fdash -Dfreedom.environment=dev -Dspring.profiles.active=dev -Dfdash.infra.overridde=-msr -Dcloud.aws.region.static=us-east-1 -Dcloud.aws.region.auto=false"
java_secret_pri = "-Dfreedom.app.name=fdash -Dfreedom.environment=dev -Dspring.profiles.active=dev -Dfdash.infra.overridde=-pri -Dcloud.aws.region.static=us-east-1 -Dcloud.aws.region.auto=false"

# Autoscaling

min_capacity        = 1
max_capacity        = 5
cpu_target_value    = 50
memory_target_value = 60

oneag_container_name          = "OneAgentInit"
oneag_container_image         = "996190702173.dkr.ecr.us-east-1.amazonaws.com/alpineimage_dev"
oneag_container_image_version = "3"
oneag_command                 = "ARCHIVE=$(mktemp) && wget -O "
oneag_api_url                 = "https://mvd33521.live.dynatrace.com/api"
oneag_options                 = "flavor=default&include=all"
oneag_pass_token              = "dt0c01.IVABFYEQFRXKG2DLAFE6ELXD.YOYVGJFVZ6H45KJHGSXK3ZHIVCHZWBOU5ZOQZH2SFGTEZ2C7GLZV5H7OASVJFVPX"
oneag_entrypoint              = ["/bin/sh", "-c"]
ld_preload_cmd                = "/opt/dynatrace/oneagent/agent/lib64/liboneagentproc.so"

oneag_taskvol        = "oneAgentVol"
oneag_container_path = "/opt/dynatrace/oneagent"
