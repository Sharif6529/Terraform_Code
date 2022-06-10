# aws_profile = "996190702173_Dash_Developer_Terraform"
aws_region = "us-east-1"
env        = "prod"
app        = "FDASH"
appName    = "fdash-extraction"
app_name   = "fdash-dash-ui"
app_name2  = "fdash-api-service"
app_name3  = "fdash-classification"
app_name4  = "fdash-event-service"
app_name5  = "fdash-auth-service"
app_name6  = "fdash-field-service"
app_name7  = "fdash-audit-service"
app_name8  = "fdash-comparison-service"
app_name9  = "fdash-integration-service"
app_name10 = "fdash-wrapper-service"


# Networking
domain     = "fhmcdev.cloud"
vpc_id     = "vpc-8f6ad1ea "
subnets    = ["subnet-0a88439c3450ad0b5", "subnet-0baed06a2257e2c6a"]
cidr_list  = ["10.0.0.0/8"]
redis_dash = "sg-0abffc49c769b6e1f"

# EC2
ec2_count       = 3
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
albLogBucket                      = "fhmc-dev-logs"
health_check_url_events           = "/eventprocessingservice/actuator/health"
health_check_url_api              = "/apiservice/actuator/health"
health_check_url_ui               = "/"
health_check_url_auth             = "/authservice/actuator/health"
health_check_url_classify         = "/extractionservice/actuator/health"
health_check_url_extract          = "/extractionservice/actuator/health"
health_check_url_field_extraction = "/extractionservice/actuator/health"
health_check_url_audit            = "/auditservice/actuator/health"
health_check_url_comparison       = "/comparisonservice/actuator/health"
health_check_url_integration      = "/integrationservice/actuator/health"
health_check_url_wrapper          = "/wrapperservice/actuator/health"
ssl_policy                        = "ELBSecurityPolicy-FS-1-2-2019-08"

# Environment Variables

# Container
container_name  = "fdash-extract"
container_name1 = "fdash-ui"
container_name2 = "fdash-api"
container_name3 = "fdash-classify"
container_name4 = "fdash-events"
container_name5 = "fdash-auth"

container_name6  = "fdash-field-extract"
container_name7  = "fdash-audit"
container_name8  = "fdash-comparison"
container_name9  = "fdash-integration"
container_name10 = "fdash-wrapper"

container_name_extract_msr  = "fdash-extract-msr"
container_name_extract_pri  = "fdash-extract-pri"
container_name_event_msr    = "fdash-events-msr"
container_name_event_pri    = "fdash-events-pri"
container_name_field_msr    = "fdash-field-extract-msr"
container_name_field_pri    = "fdash-field-extract-pri"
container_name_classify_msr = "fdash-classify-msr"
container_name_classify_pri = "fdash-classify-pri"

container_image   = "996190702173.dkr.ecr.us-east-1.amazonaws.com/fdash-extraction-service-dev:latest"
container_image1  = "996190702173.dkr.ecr.us-east-1.amazonaws.com/fdash-dash-ui-dev:aws"
container_image2  = "996190702173.dkr.ecr.us-east-1.amazonaws.com/fdash-api-service-dev:latest"
container_image3  = "996190702173.dkr.ecr.us-east-1.amazonaws.com/fdash-classification-service-dev:latest"
container_image4  = "996190702173.dkr.ecr.us-east-1.amazonaws.com/fdash-event-processing-service-dev:latest"
container_image5  = "996190702173.dkr.ecr.us-east-1.amazonaws.com/fdash-auth-service-dev:latest"
container_image6  = "996190702173.dkr.ecr.us-east-1.amazonaws.com/fdash-field-extraction-service-dev:latest"
container_image7  = "996190702173.dkr.ecr.us-east-1.amazonaws.com/fdash-audit-log-service-dev:latest"
container_image8  = "996190702173.dkr.ecr.us-east-1.amazonaws.com/fdash-comparison-service-dev:ecs"
container_image9  = "996190702173.dkr.ecr.us-east-1.amazonaws.com/fdash-integration-service-dev:latest"
container_image10 = "996190702173.dkr.ecr.us-east-1.amazonaws.com/fdash-wrapper-service-dev:ecs"

container_cpu    = "1024" # 1 vCPU
container_memory = "4096" # 2GB ram
container_port   = 8088
container_port1  = 80
container_port2  = 8085
container_port3  = 8088
container_port4  = 8086
container_port5  = 8087
container_port6  = 8088
container_port7  = 8089
container_port8  = 8092
container_port9  = 8091
container_port10 = 8093
host_port        = 8088
host_port1       = 80
host_port2       = 8085
host_port3       = 8020
host_port4       = 8086
host_port5       = 8087
host_port6       = 8020
host_port7       = 8089
host_port8       = 8092
host_port9       = 8091
host_port10      = 8093

desireCount = 1
volumes = [
  { name = "docs", host_path = "/docs" },
]
mount_points = [
  { "sourceVolume" : "docs", "containerPath" : "/docs", "readOnly" : false },
]

log_groups = [
  "ecs-api-prod", "ecs-event-prod", "ecs-classify-prod", "ecs-auth-prod", "ecs-ui-prod", "ecs-extract-prod",
  "ecs-field-prod", "ecs-audit-prod", "ecs-comparison-prod", "ecs-integration-prod", "ecs-wrapper-prod"
]

log_groups_pri = [
  "ecs-event-prod-pri", "ecs-classify-prod-pri", "ecs-extract-prod-pri", "ecs-field-prod-pri"
]

log_groups_msr = [
  "ecs-event-prod-msr", "ecs-classify-prod-msr", "ecs-extract-prod-msr", "ecs-field-prod-msr"
]

service_name = [
  "extract-ec2", "ui-fg", "api-fg", "classify-fg", "events-fg", "auth-fg",
  "field-extraction-fg", "audit-fg", "comparison-fg", "integration-fg", "wrapper-fg"
]
log_configuration_api_new         = "/ecs-api-prod"
log_configuration_events_new      = "/ecs-event-prod"
log_configuration_classify_new    = "/ecs-classify-prod"
log_configuration_ui_new          = "/ecs-ui-prod"
log_configuration_auth_new        = "/ecs-auth-prod"
log_configuration_field_new       = "/ecs-field-prod"
log_configuration_audit_new       = "/ecs-audit-prod"
log_configuration_comparison_new  = "/ecs-comparison-prod"
log_configuration_integration_new = "/ecs-integration-prod"
log_configuration_wrapper_new     = "/ecs-wrapper-prod"
log_configuration_extract_new     = "/ecs-extract-prod"

# Env Variable 

java_secret     = "-Dfreedom.app.name=fdash -Dfreedom.environment=prod -Dspring.profiles.active=prod -Dcloud.aws.region.static=us-east-1 -Dcloud.aws.region.auto=false"
java_secret_msr = "-Dfreedom.app.name=fdash -Dfreedom.environment=prod -Dspring.profiles.active=prod -Dfdash.infra.overridde=-msr -Dcloud.aws.region.static=us-east-1 -Dcloud.aws.region.auto=false"
java_secret_pri = "-Dfreedom.app.name=fdash -Dfreedom.environment=prod -Dspring.profiles.active=prod -Dfdash.infra.overridde=-pri -Dcloud.aws.region.static=us-east-1 -Dcloud.aws.region.auto=false"


# Autoscaling

min_capacity        = 1
max_capacity        = 5
cpu_target_value    = 50
memory_target_value = 60

oneag_taskvol        = "oneAgentVol"
oneag_container_path = "/opt/dynatrace/oneagent"
