provider "aws" {
  region = var.aws_region
  # profile = var.aws_profile
}
terraform {
  backend "s3" {
    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
locals {
  # Common tags to be assigned to all resources
  common_tags = {
    Name            = var.appName
    Environment     = var.env
    AppName         = "DASH"
    BusinessAppName = "DASH"
    AppOwner        = "Samir Shah"
    Description     = "DASH ECS cluster for DASH"
    Terraformed     = true
  }
}

locals {
  # Variable to identify dev account with prod AWS account
  only_in_prod_account = {
    dev  = 0
    test = 0
    perf = 0
    uat  = 1
    prod = 1
  }

  prod_account = local.only_in_prod_account[var.env]
}

module "pri" {
  source = "./PRI"

  log_groups_pri                    = var.log_groups_pri
  java_secret_pri                   = var.java_secret_pri
  env                               = var.env
  max_capacity                      = var.max_capacity
  min_capacity                      = var.min_capacity
  memory_target_value               = var.memory_target_value
  cpu_target_value                  = var.cpu_target_value
  subnets                           = var.subnets
  ecs_task_execution_role_arn       = var.ecs_task_execution_role_arn
  container_memory                  = var.container_memory
  container_cpu                     = var.container_cpu
  container_image                   = var.container_image
  container_image1                  = var.container_image1
  container_image2                  = var.container_image2
  container_image3                  = var.container_image3
  container_image4                  = var.container_image4
  container_image5                  = var.container_image5
  container_image6                  = var.container_image6
  container_image7                  = var.container_image7
  container_image8                  = var.container_image8
  container_image9                  = var.container_image9
  container_image10                 = var.container_image10
  container_image11                 = var.container_image11
  log_configuration_api_new         = var.log_configuration_api_new
  log_configuration_auth_new        = var.log_configuration_auth_new
  log_configuration_events_new      = var.log_configuration_events_new
  log_configuration_classify_new    = var.log_configuration_classify_new
  log_configuration_field_new       = var.log_configuration_field_new
  log_configuration_comparison_new  = var.log_configuration_comparison_new
  log_configuration_integration_new = var.log_configuration_integration_new
  log_configuration_wrapper_new     = var.log_configuration_wrapper_new
  log_configuration_stitching_new   = var.log_configuration_stitching_new
  log_configuration_extract_new     = var.log_configuration_extract_new
  oneag_container_image             = var.oneag_container_image
  oneag_pass_token                  = var.oneag_pass_token
  ld_preload_cmd                    = var.ld_preload_cmd
  extractioncontainer_cpu           = var.extractioncontainer_cpu
  pythoncontainer_cpu               = var.pythoncontainer_cpu
  pythoncontainer_memory            = var.pythoncontainer_memory
  redis_dash                        = var.redis_dash
  extractioncontainer_memory        = var.extractioncontainer_memory
  autoscaling_group_pri             = aws_autoscaling_group.ec2-asg_pri.name
  common_tags                       = local.common_tags
  https                             = [aws_alb_listener.https]
  volumes                           = var.volumes
  mount_points                      = var.mount_points
  cluster-sg                        = aws_security_group.cluster-sg.id
  redis-sg                          = data.aws_security_group.redis_dash.id
  https_arn                         = aws_alb_listener.https.arn
  vpc_id                            = var.vpc_id

}

module "msr" {
  source = "./MSR"

  log_groups_msr                    = var.log_groups_msr
  java_secret_msr                   = var.java_secret_msr
  env                               = var.env
  max_capacity                      = var.max_capacity
  min_capacity                      = var.min_capacity
  memory_target_value               = var.memory_target_value
  cpu_target_value                  = var.cpu_target_value
  subnets                           = var.subnets
  ecs_task_execution_role_arn       = var.ecs_task_execution_role_arn
  container_memory                  = var.container_memory
  container_cpu                     = var.container_cpu
  container_image                   = var.container_image
  container_image1                  = var.container_image1
  container_image2                  = var.container_image2
  container_image3                  = var.container_image3
  container_image4                  = var.container_image4
  container_image5                  = var.container_image5
  container_image6                  = var.container_image6
  container_image7                  = var.container_image7
  container_image8                  = var.container_image8
  container_image9                  = var.container_image9
  container_image10                 = var.container_image10
  container_image11                 = var.container_image11
  log_configuration_api_new         = var.log_configuration_api_new
  log_configuration_auth_new        = var.log_configuration_auth_new
  log_configuration_events_new      = var.log_configuration_events_new
  log_configuration_classify_new    = var.log_configuration_classify_new
  log_configuration_field_new       = var.log_configuration_field_new
  log_configuration_comparison_new  = var.log_configuration_comparison_new
  log_configuration_integration_new = var.log_configuration_integration_new
  log_configuration_wrapper_new     = var.log_configuration_wrapper_new
  log_configuration_stitching_new   = var.log_configuration_stitching_new
  log_configuration_extract_new     = var.log_configuration_extract_new
  oneag_container_image             = var.oneag_container_image
  oneag_pass_token                  = var.oneag_pass_token
  ld_preload_cmd                    = var.ld_preload_cmd
  extractioncontainer_cpu           = var.extractioncontainer_cpu
  pythoncontainer_cpu               = var.pythoncontainer_cpu
  pythoncontainer_memory            = var.pythoncontainer_memory
  redis_dash                        = var.redis_dash
  extractioncontainer_memory        = var.extractioncontainer_memory
  autoscaling_group_msr             = aws_autoscaling_group.ec2-asg_msr.name
  common_tags                       = local.common_tags
  https                             = [aws_alb_listener.https]
  volumes                           = var.volumes
  mount_points                      = var.mount_points
  cluster-sg                        = aws_security_group.cluster-sg.id
  redis-sg                          = data.aws_security_group.redis_dash.id
  https_arn                         = aws_alb_listener.https.arn
  vpc_id                            = var.vpc_id
}