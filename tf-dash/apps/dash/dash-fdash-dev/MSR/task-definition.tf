data "template_file" "extract_msr" {
  template = file("task_json/extract.json")

  vars = {
    app_name                   = var.app_name
    container_name             = var.container_name
    container_image            = "${var.container_image}:${var.fdash-extraction-image}"
    container_port             = var.container_port
    log_configuration_extract  = "${var.log_configuration_extract_new}-msr"
    host_port                  = var.host_port
    java_secret                = var.java_secret_msr
    extractioncontainer_cpu    = var.extractioncontainer_cpu
    extractioncontainer_memory = var.extractioncontainer_memory
    #Added for OneAgent
    ld_preload_cmd               = var.ld_preload_cmd
    dependent_container_name     = var.oneag_container_name
    ag_container_name            = var.oneag_container_name
    ag_container_image           = join(":", [var.oneag_container_image, var.oneag_container_image_version])
    ag_command                   = var.oneag_command
    dt_api_url                   = var.oneag_api_url
    dt_oneagent_options          = var.oneag_options
    dt_pass_token                = var.oneag_pass_token
    log_configuration_extract_ag = "${var.log_configuration_extract_new}-msr"
  }
}

resource "aws_ecs_task_definition" "task_extract_msr" {
  family                   = var.container_name_extract_msr
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_execution_role_arn
  container_definitions    = data.template_file.extract_msr.rendered
  cpu                      = var.extractioncontainer_cpu
  memory                   = var.extractioncontainer_memory
  requires_compatibilities = ["EC2"]
  skip_destroy             = true
  tags                     = var.common_tags
  dynamic "volume" {
    for_each = var.volumes
    content {
      name      = volume.value.name
      host_path = lookup(volume.value, "host_path", null)
    }
  }
}

data "template_file" "api_msr" {
  template = file("task_json/api.json")

  vars = {
    app_name         = var.app_name2
    container_name2  = var.container_name2
    container_image2 = "${var.container_image2}:${var.fdash-api-service-image}"
    container_port2  = var.container_port2
    host_port2       = var.host_port2
    # container_port= 443
    java_secret           = var.java_secret_msr
    container_cpu         = var.container_cpu
    container_memory      = var.container_memory
    log_configuration_api = "${var.log_configuration_api_new}-msr"
    # aws_region     = var.aws_region
    # Added for OneAgent
    ld_preload_cmd           = var.ld_preload_cmd
    dependent_container_name = var.oneag_container_name
    ag_container_name        = var.oneag_container_name
    ag_container_image       = join(":", [var.oneag_container_image, var.oneag_container_image_version])
    ag_command               = var.oneag_command
    dt_api_url               = var.oneag_api_url
    dt_oneagent_options      = var.oneag_options
    dt_pass_token            = var.oneag_pass_token
    buss_cont_SourceVolume   = var.oneag_taskvol
    buss_cont_ContainerVol   = var.oneag_container_path
    oneAgent_SourceVolume    = var.oneag_taskvol
    oneAgent_ContainerVol    = var.oneag_container_path
    log_configuration_api_ag = "${var.log_configuration_api_new}-msr"
  }
}

resource "aws_ecs_task_definition" "task_api_msr" {
  family                   = var.container_name_api_msr
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_execution_role_arn
  container_definitions    = data.template_file.api_msr.rendered
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  requires_compatibilities = ["FARGATE"]
  skip_destroy             = true
  tags                     = var.common_tags
  volume {
    name = var.oneag_taskvol
  }
}

data "template_file" "classify_msr" {
  template = file("task_json/classify.json")

  vars = {
    app_name                   = var.app_name3
    container_name3            = var.container_name3
    container_image3           = "${var.container_image3}:${var.fdash-classification-image}"
    container_port3            = var.container_port3
    log_configuration_classify = "${var.log_configuration_classify_new}-msr"
    host_port3                 = var.host_port3
    env                        = var.env
    infra                      = "msr"
    pythoncontainer_cpu        = var.pythoncontainer_cpu
    pythoncontainer_memory     = var.pythoncontainer_memory
    #Added for OneAgent
    ld_preload_cmd                = var.ld_preload_cmd
    dependent_container_name      = var.oneag_container_name
    ag_container_name             = var.oneag_container_name
    ag_container_image            = join(":", [var.oneag_container_image, var.oneag_container_image_version])
    ag_command                    = var.oneag_command
    dt_api_url                    = var.oneag_api_url
    dt_oneagent_options           = var.oneag_options
    dt_pass_token                 = var.oneag_pass_token
    buss_cont_SourceVolume        = var.oneag_taskvol
    buss_cont_ContainerVol        = var.oneag_container_path
    oneAgent_SourceVolume         = var.oneag_taskvol
    oneAgent_ContainerVol         = var.oneag_container_path
    log_configuration_classify_ag = "${var.log_configuration_classify_new}-msr"
  }
}

resource "aws_ecs_task_definition" "task_classify_msr" {
  family                   = var.container_name_classify_msr
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_execution_role_arn
  container_definitions    = data.template_file.classify_msr.rendered
  cpu                      = var.pythoncontainer_cpu
  memory                   = var.pythoncontainer_memory
  requires_compatibilities = ["FARGATE"]
  skip_destroy             = true
  tags                     = var.common_tags
  volume {
    name = var.oneag_taskvol
  }
}

data "template_file" "events_msr" {
  template = file("task_json/events.json")

  vars = {
    app_name                 = var.app_name4
    container_name4          = var.container_name4
    container_image4         = "${var.container_image4}:${var.fdash-event-service-image}"
    container_port4          = var.container_port4
    log_configuration_events = "${var.log_configuration_events_new}-msr"
    host_port4               = var.host_port4
    java_secret              = var.java_secret_msr
    container_cpu            = var.container_cpu
    container_memory         = var.container_memory
    #Added for OneAgent
    ld_preload_cmd              = var.ld_preload_cmd
    dependent_container_name    = var.oneag_container_name
    ag_container_name           = var.oneag_container_name
    ag_container_image          = join(":", [var.oneag_container_image, var.oneag_container_image_version])
    ag_command                  = var.oneag_command
    dt_api_url                  = var.oneag_api_url
    dt_oneagent_options         = var.oneag_options
    dt_pass_token               = var.oneag_pass_token
    buss_cont_SourceVolume      = var.oneag_taskvol
    buss_cont_ContainerVol      = var.oneag_container_path
    oneAgent_SourceVolume       = var.oneag_taskvol
    oneAgent_ContainerVol       = var.oneag_container_path
    log_configuration_events_ag = "${var.log_configuration_events_new}-msr"
  }
}

resource "aws_ecs_task_definition" "task_event_msr" {
  family                   = var.container_name_event_msr
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_execution_role_arn
  container_definitions    = data.template_file.events_msr.rendered
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  requires_compatibilities = ["FARGATE"]
  skip_destroy             = true
  tags                     = var.common_tags
  volume {
    name = var.oneag_taskvol
  }
}

data "template_file" "field_msr" {
  template = file("task_json/field.json")

  vars = {
    app_name                    = var.app_name6
    container_name6             = var.container_name6
    container_image6            = "${var.container_image6}:${var.fdash-field-service-image}"
    container_port6             = var.container_port6
    log_configuration_field_new = "${var.log_configuration_field_new}-msr"
    host_port6                  = var.host_port6
    # container_port= 443
    env                    = var.env
    infra                  = "msr"
    pythoncontainer_cpu    = var.pythoncontainer_cpu
    pythoncontainer_memory = var.pythoncontainer_memory
    # aws_region     = var.aws_region
    #Added for OneAgent
    ld_preload_cmd                 = var.ld_preload_cmd
    dependent_container_name       = var.oneag_container_name
    ag_container_name              = var.oneag_container_name
    ag_container_image             = join(":", [var.oneag_container_image, var.oneag_container_image_version])
    ag_command                     = var.oneag_command
    dt_api_url                     = var.oneag_api_url
    dt_oneagent_options            = var.oneag_options
    dt_pass_token                  = var.oneag_pass_token
    buss_cont_SourceVolume         = var.oneag_taskvol
    buss_cont_ContainerVol         = var.oneag_container_path
    oneAgent_SourceVolume          = var.oneag_taskvol
    oneAgent_ContainerVol          = var.oneag_container_path
    log_configuration_field_new_ag = "${var.log_configuration_field_new}-msr"
  }
}

resource "aws_ecs_task_definition" "task_field_msr" {
  family                   = var.container_name_field_msr
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_execution_role_arn
  container_definitions    = data.template_file.field_msr.rendered
  cpu                      = var.pythoncontainer_cpu
  memory                   = var.pythoncontainer_memory
  requires_compatibilities = ["FARGATE"]
  skip_destroy             = true
  tags                     = var.common_tags
  volume {
    name = var.oneag_taskvol
  }
}

data "template_file" "comparison_msr" {
  template = file("task_json/comparison.json")

  vars = {
    app_name                     = var.app_name8
    container_name8              = var.container_name8
    container_image8             = "${var.container_image8}:${var.fdash-comparison-service-image}"
    container_port8              = var.container_port8
    log_configuration_comparison = "${var.log_configuration_comparison_new}-msr"
    host_port8                   = var.host_port8
    # container_port= 443
    java_secret      = var.java_secret_msr
    container_cpu    = var.container_cpu
    container_memory = var.container_memory
    # aws_region     = var.aws_region
    #Added for OneAgent
    ld_preload_cmd                  = var.ld_preload_cmd
    dependent_container_name        = var.oneag_container_name
    ag_container_name               = var.oneag_container_name
    ag_container_image              = join(":", [var.oneag_container_image, var.oneag_container_image_version])
    ag_command                      = var.oneag_command
    dt_api_url                      = var.oneag_api_url
    dt_oneagent_options             = var.oneag_options
    dt_pass_token                   = var.oneag_pass_token
    buss_cont_SourceVolume          = var.oneag_taskvol
    buss_cont_ContainerVol          = var.oneag_container_path
    oneAgent_SourceVolume           = var.oneag_taskvol
    oneAgent_ContainerVol           = var.oneag_container_path
    log_configuration_comparison_ag = "${var.log_configuration_comparison_new}-msr"
  }
}

resource "aws_ecs_task_definition" "task_comparison_msr" {
  family                   = var.container_name_comparison_msr
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_execution_role_arn
  container_definitions    = data.template_file.comparison_msr.rendered
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  requires_compatibilities = ["FARGATE"]
  skip_destroy             = true
  tags                     = var.common_tags
  volume {
    name = var.oneag_taskvol
  }
}

data "template_file" "integration_msr" {
  template = file("task_json/integration.json")

  vars = {
    app_name                      = var.app_name9
    container_name9               = var.container_name9
    container_image9              = "${var.container_image9}:${var.fdash-integration-service-image}"
    container_port9               = var.container_port9
    log_configuration_integration = "${var.log_configuration_integration_new}-msr"
    host_port9                    = var.host_port9
    # container_port= 443
    java_secret      = var.java_secret_msr
    container_cpu    = var.container_cpu
    container_memory = var.container_memory
    # aws_region     = var.aws_region
    #Added for OneAgent
    ld_preload_cmd                   = var.ld_preload_cmd
    dependent_container_name         = var.oneag_container_name
    ag_container_name                = var.oneag_container_name
    ag_container_image               = join(":", [var.oneag_container_image, var.oneag_container_image_version])
    ag_command                       = var.oneag_command
    dt_api_url                       = var.oneag_api_url
    dt_oneagent_options              = var.oneag_options
    dt_pass_token                    = var.oneag_pass_token
    buss_cont_SourceVolume           = var.oneag_taskvol
    buss_cont_ContainerVol           = var.oneag_container_path
    oneAgent_SourceVolume            = var.oneag_taskvol
    oneAgent_ContainerVol            = var.oneag_container_path
    log_configuration_integration_ag = "${var.log_configuration_integration_new}-msr"
  }
}

resource "aws_ecs_task_definition" "task_integration_msr" {
  family                   = var.container_name_integration_msr
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_execution_role_arn
  container_definitions    = data.template_file.integration_msr.rendered
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  requires_compatibilities = ["FARGATE"]
  skip_destroy             = true
  tags                     = var.common_tags
  volume {
    name = var.oneag_taskvol
  }
}

data "template_file" "wrapper_msr" {
  template = file("task_json/wrapper.json")

  vars = {
    app_name                  = var.app_name10
    container_name10          = var.container_name10
    container_image10         = "${var.container_image10}:${var.fdash-wrapper-service-image}"
    container_port10          = var.container_port10
    log_configuration_wrapper = "${var.log_configuration_wrapper_new}-msr"
    host_port10               = var.host_port10
    # container_port= 443
    java_secret      = var.java_secret_msr
    container_cpu    = var.container_cpu
    container_memory = var.container_memory
    # aws_region     = var.aws_region
    #Added for OneAgent
    ld_preload_cmd               = var.ld_preload_cmd
    dependent_container_name     = var.oneag_container_name
    ag_container_name            = var.oneag_container_name
    ag_container_image           = join(":", [var.oneag_container_image, var.oneag_container_image_version])
    ag_command                   = var.oneag_command
    dt_api_url                   = var.oneag_api_url
    dt_oneagent_options          = var.oneag_options
    dt_pass_token                = var.oneag_pass_token
    buss_cont_SourceVolume       = var.oneag_taskvol
    buss_cont_ContainerVol       = var.oneag_container_path
    oneAgent_SourceVolume        = var.oneag_taskvol
    oneAgent_ContainerVol        = var.oneag_container_path
    log_configuration_wrapper_ag = "${var.log_configuration_wrapper_new}-msr"
  }
}

resource "aws_ecs_task_definition" "task_wrapper_msr" {
  family                   = var.container_name_wrapper_msr
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_execution_role_arn
  container_definitions    = data.template_file.wrapper_msr.rendered
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  skip_destroy             = true
  requires_compatibilities = ["FARGATE"]
  tags                     = var.common_tags
  volume {
    name = var.oneag_taskvol
  }
}

data "template_file" "stitching_msr" {
  template = file("task_json/stitching.json")

  vars = {
    app_name                    = var.app_name11
    container_name11            = var.container_name11
    container_image11           = "${var.container_image11}:${var.fdash-stitching-service-image}"
    container_port11            = var.container_port11
    log_configuration_stitching = "${var.log_configuration_stitching_new}-msr"
    host_port11                 = var.host_port11
    # container_port= 443
    java_secret      = var.java_secret_msr
    container_cpu    = var.container_cpu
    container_memory = var.container_memory
    # aws_region     = var.aws_region
    # Added for OneAgent
    ld_preload_cmd                 = var.ld_preload_cmd
    dependent_container_name       = var.oneag_container_name
    ag_container_name              = var.oneag_container_name
    ag_container_image             = join(":", [var.oneag_container_image, var.oneag_container_image_version])
    ag_command                     = var.oneag_command
    dt_api_url                     = var.oneag_api_url
    dt_oneagent_options            = var.oneag_options
    dt_pass_token                  = var.oneag_pass_token
    buss_cont_SourceVolume         = var.oneag_taskvol
    buss_cont_ContainerVol         = var.oneag_container_path
    oneAgent_SourceVolume          = var.oneag_taskvol
    oneAgent_ContainerVol          = var.oneag_container_path
    log_configuration_stitching_ag = "${var.log_configuration_stitching_new}-msr"
  }
}

resource "aws_ecs_task_definition" "task_stitching_msr" {
  family                   = var.container_name_stitching_msr
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_execution_role_arn
  container_definitions    = data.template_file.stitching_msr.rendered
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  requires_compatibilities = ["FARGATE"]
  skip_destroy             = true
  tags                     = var.common_tags

  volume {
    name = var.oneag_taskvol
  }
}

