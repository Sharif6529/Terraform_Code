data "template_file" "extract_pri" {
  template = file("task_json/extract.json")

  vars = {
    app_name                   = var.app_name
    container_name             = var.container_name
    container_image            = "${var.container_image}:${var.fdash-extraction-image}"
    container_port             = var.container_port
    log_configuration_extract  = "${var.log_configuration_extract_new}-pri"
    host_port                  = var.host_port
    java_secret                = var.java_secret_pri
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
    log_configuration_extract_ag = "${var.log_configuration_extract_new}-pri"
  }
}

resource "aws_ecs_task_definition" "task_extract_pri" {
  family                   = var.container_name_extract_pri
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_execution_role_arn
  container_definitions    = data.template_file.extract_pri.rendered
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

data "template_file" "api_pri" {
  template = file("task_json/api.json")

  vars = {
    app_name         = var.app_name2
    container_name2  = var.container_name2
    container_image2 = "${var.container_image2}:${var.fdash-api-service-image}"
    container_port2  = var.container_port2
    host_port2       = var.host_port2
    # container_port= 443
    java_secret           = var.java_secret_pri
    container_cpu         = var.container_cpu
    container_memory      = var.container_memory
    log_configuration_api = "${var.log_configuration_api_new}-pri"
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
    log_configuration_api_ag = "${var.log_configuration_api_new}-pri"
  }
}

resource "aws_ecs_task_definition" "task_api_pri" {
  family                   = var.container_name_api_pri
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_execution_role_arn
  container_definitions    = data.template_file.api_pri.rendered
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  requires_compatibilities = ["FARGATE"]
  skip_destroy             = true
  tags                     = var.common_tags
  volume {
    name = var.oneag_taskvol
  }
}

data "template_file" "classify_pri" {
  template = file("task_json/classify.json")

  vars = {
    app_name                   = var.app_name3
    container_name3            = var.container_name3
    container_image3           = "${var.container_image3}:${var.fdash-classification-image}"
    container_port3            = var.container_port3
    log_configuration_classify = "${var.log_configuration_classify_new}-pri"
    host_port3                 = var.host_port3
    env                        = var.env
    infra                      = "pri"
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
    log_configuration_classify_ag = "${var.log_configuration_classify_new}-pri"
  }
}

resource "aws_ecs_task_definition" "task_classify_pri" {
  family                   = var.container_name_classify_pri
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_execution_role_arn
  container_definitions    = data.template_file.classify_pri.rendered
  cpu                      = var.pythoncontainer_cpu
  memory                   = var.pythoncontainer_memory
  requires_compatibilities = ["FARGATE"]
  skip_destroy             = true
  tags                     = var.common_tags
  volume {
    name = var.oneag_taskvol
  }
}

data "template_file" "events_pri" {
  template = file("task_json/events.json")

  vars = {
    app_name                 = var.app_name4
    container_name4          = var.container_name4
    container_image4         = "${var.container_image4}:${var.fdash-event-service-image}"
    container_port4          = var.container_port4
    log_configuration_events = "${var.log_configuration_events_new}-pri"
    host_port4               = var.host_port4
    java_secret              = var.java_secret_pri
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
    log_configuration_events_ag = "${var.log_configuration_events_new}-pri"
  }
}

resource "aws_ecs_task_definition" "task_event_pri" {
  family                   = var.container_name_event_pri
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_execution_role_arn
  container_definitions    = data.template_file.events_pri.rendered
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  requires_compatibilities = ["FARGATE"]
  skip_destroy             = true
  tags                     = var.common_tags
  volume {
    name = var.oneag_taskvol
  }
}

data "template_file" "field_pri" {
  template = file("task_json/field.json")

  vars = {
    app_name                    = var.app_name6
    container_name6             = var.container_name6
    container_image6            = "${var.container_image6}:${var.fdash-field-service-image}"
    container_port6             = var.container_port6
    log_configuration_field_new = "${var.log_configuration_field_new}-pri"
    host_port6                  = var.host_port6
    # container_port= 443
    env                    = var.env
    infra                  = "pri"
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
    log_configuration_field_new_ag = "${var.log_configuration_field_new}-pri"
  }
}

resource "aws_ecs_task_definition" "task_field_pri" {
  family                   = var.container_name_field_pri
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_execution_role_arn
  container_definitions    = data.template_file.field_pri.rendered
  cpu                      = var.pythoncontainer_cpu
  memory                   = var.pythoncontainer_memory
  requires_compatibilities = ["FARGATE"]
  skip_destroy             = true
  tags                     = var.common_tags
  volume {
    name = var.oneag_taskvol
  }
}

data "template_file" "comparison_pri" {
  template = file("task_json/comparison.json")

  vars = {
    app_name                     = var.app_name8
    container_name8              = var.container_name8
    container_image8             = "${var.container_image8}:${var.fdash-comparison-service-image}"
    container_port8              = var.container_port8
    log_configuration_comparison = "${var.log_configuration_comparison_new}-pri"
    host_port8                   = var.host_port8
    # container_port= 443
    java_secret      = var.java_secret_pri
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
    log_configuration_comparison_ag = "${var.log_configuration_comparison_new}-pri"
  }
}

resource "aws_ecs_task_definition" "task_comparison_pri" {
  family                   = var.container_name_comparison_pri
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_execution_role_arn
  container_definitions    = data.template_file.comparison_pri.rendered
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  requires_compatibilities = ["FARGATE"]
  skip_destroy             = true
  tags                     = var.common_tags
  volume {
    name = var.oneag_taskvol
  }
}

data "template_file" "integration_pri" {
  template = file("task_json/integration.json")

  vars = {
    app_name                      = var.app_name9
    container_name9               = var.container_name9
    container_image9              = "${var.container_image9}:${var.fdash-integration-service-image}"
    container_port9               = var.container_port9
    log_configuration_integration = "${var.log_configuration_integration_new}-pri"
    host_port9                    = var.host_port9
    # container_port= 443
    java_secret      = var.java_secret_pri
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
    log_configuration_integration_ag = "${var.log_configuration_integration_new}-pri"
  }
}

resource "aws_ecs_task_definition" "task_integration_pri" {
  family                   = var.container_name_integration_pri
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_execution_role_arn
  container_definitions    = data.template_file.integration_pri.rendered
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  requires_compatibilities = ["FARGATE"]
  skip_destroy             = true
  tags                     = var.common_tags
  volume {
    name = var.oneag_taskvol
  }
}

data "template_file" "wrapper_pri" {
  template = file("task_json/wrapper.json")

  vars = {
    app_name                  = var.app_name10
    container_name10          = var.container_name10
    container_image10         = "${var.container_image10}:${var.fdash-wrapper-service-image}"
    container_port10          = var.container_port10
    log_configuration_wrapper = "${var.log_configuration_wrapper_new}-pri"
    host_port10               = var.host_port10
    # container_port= 443
    java_secret      = var.java_secret_pri
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
    log_configuration_wrapper_ag = "${var.log_configuration_wrapper_new}-pri"
  }
}

resource "aws_ecs_task_definition" "task_wrapper_pri" {
  family                   = var.container_name_wrapper_pri
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_execution_role_arn
  container_definitions    = data.template_file.wrapper_pri.rendered
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  skip_destroy             = true
  requires_compatibilities = ["FARGATE"]
  tags                     = var.common_tags
  volume {
    name = var.oneag_taskvol
  }
}

data "template_file" "stitching_pri" {
  template = file("task_json/stitching.json")

  vars = {
    app_name                    = var.app_name11
    container_name11            = var.container_name11
    container_image11           = "${var.container_image11}:${var.fdash-stitching-service-image}"
    container_port11            = var.container_port11
    log_configuration_stitching = "${var.log_configuration_stitching_new}-pri"
    host_port11                 = var.host_port11
    # container_port= 443
    java_secret      = var.java_secret_pri
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
    log_configuration_stitching_ag = "${var.log_configuration_stitching_new}-pri"
  }
}

resource "aws_ecs_task_definition" "task_stitching_pri" {
  family                   = var.container_name_stitching_pri
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_execution_role_arn
  container_definitions    = data.template_file.stitching_pri.rendered
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  requires_compatibilities = ["FARGATE"]
  skip_destroy             = true
  tags                     = var.common_tags

  volume {
    name = var.oneag_taskvol
  }
}
