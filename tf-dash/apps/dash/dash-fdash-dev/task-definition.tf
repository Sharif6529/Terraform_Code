data "template_file" "extract" {
  template = file("task_json/extract.json")

  vars = {
    app_name                   = var.app_name
    container_name             = var.container_name
    container_image            = "${var.container_image}:${var.fdash-extraction-image}"
    container_port             = var.container_port
    log_configuration_extract  = var.log_configuration_extract_new
    host_port                  = var.host_port
    java_secret                = var.java_secret
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
    log_configuration_extract_ag = var.log_configuration_extract_new
  }
}

resource "aws_ecs_task_definition" "task" {
  family                   = var.container_name
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_execution_role_arn
  container_definitions    = data.template_file.extract.rendered
  cpu                      = var.extractioncontainer_cpu
  memory                   = var.extractioncontainer_memory
  requires_compatibilities = ["EC2"]
  skip_destroy             = true
  tags                     = local.common_tags
  dynamic "volume" {
    for_each = var.volumes
    content {
      name      = volume.value.name
      host_path = lookup(volume.value, "host_path", null)
    }
  }
}

data "template_file" "ui_app" {
  template = file("task_json/ui.json")

  vars = {
    app_name         = var.app_name
    container_name1  = var.container_name1
    container_image1 = "${var.container_image1}:${var.fdash-dash-ui-image}"
    container_port1  = var.container_port1
    host_port1       = var.host_port1
    # container_port= 443
    container_cpu        = var.container_cpu
    container_memory     = var.container_memory
    log_configuration_ui = var.log_configuration_ui_new
    # aws_region     = var.aws_region
    #Added for OneAgent
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
    log_configuration_ui_ag  = var.log_configuration_ui_new
  }
}

resource "aws_ecs_task_definition" "task1" {
  family                   = var.container_name1
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_execution_role_arn
  container_definitions    = data.template_file.ui_app.rendered
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  requires_compatibilities = ["FARGATE"]
  skip_destroy             = true
  tags                     = local.common_tags
  volume {
    name = var.oneag_taskvol
  }
}

data "template_file" "api_app" {
  template = file("task_json/api.json")

  vars = {
    app_name         = var.app_name2
    container_name2  = var.container_name2
    container_image2 = "${var.container_image2}:${var.fdash-api-service-image}"
    container_port2  = var.container_port2
    host_port2       = var.host_port2
    # container_port= 443
    java_secret           = var.java_secret
    container_cpu         = var.container_cpu
    container_memory      = var.container_memory
    log_configuration_api = var.log_configuration_api_new
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
    log_configuration_api_ag = var.log_configuration_api_new
  }
}

resource "aws_ecs_task_definition" "task2" {
  family                   = var.container_name2
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_execution_role_arn
  container_definitions    = data.template_file.api_app.rendered
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  requires_compatibilities = ["FARGATE"]
  skip_destroy             = true
  tags                     = local.common_tags
  volume {
    name = var.oneag_taskvol
  }
}

data "template_file" "classify" {
  template = file("task_json/classify.json")

  vars = {
    app_name                   = var.app_name3
    container_name3            = var.container_name3
    container_image3           = "${var.container_image3}:${var.fdash-classification-image}"
    container_port3            = var.container_port3
    log_configuration_classify = var.log_configuration_classify_new
    host_port3                 = var.host_port3
    env                        = var.env
    infra                      = "normal"
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
    log_configuration_classify_ag = var.log_configuration_classify_new
  }
}

resource "aws_ecs_task_definition" "task3" {
  family                   = var.container_name3
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_execution_role_arn
  container_definitions    = data.template_file.classify.rendered
  cpu                      = var.pythoncontainer_cpu
  memory                   = var.pythoncontainer_memory
  requires_compatibilities = ["FARGATE"]
  skip_destroy             = true
  tags                     = local.common_tags
  volume {
    name = var.oneag_taskvol
  }
}

data "template_file" "events" {
  template = file("task_json/events.json")

  vars = {
    app_name                 = var.app_name4
    container_name4          = var.container_name4
    container_image4         = "${var.container_image4}:${var.fdash-event-service-image}"
    container_port4          = var.container_port4
    log_configuration_events = var.log_configuration_events_new
    host_port4               = var.host_port4
    # container_port= 443
    java_secret      = var.java_secret
    container_cpu    = var.container_cpu
    container_memory = var.container_memory
    # aws_region     = var.aws_region
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
    log_configuration_events_ag = var.log_configuration_events_new
  }
}

resource "aws_ecs_task_definition" "task4" {
  family                   = var.container_name4
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_execution_role_arn
  container_definitions    = data.template_file.events.rendered
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  requires_compatibilities = ["FARGATE"]
  skip_destroy             = true
  tags                     = local.common_tags
  volume {
    name = var.oneag_taskvol
  }
}

data "template_file" "auth" {
  template = file("task_json/auth.json")

  vars = {
    app_name               = var.app_name5
    container_name5        = var.container_name5
    container_image5       = "${var.container_image5}:${var.fdash-auth-service-image}"
    container_port5        = var.container_port5
    log_configuration_auth = var.log_configuration_auth_new
    host_port5             = var.host_port5
    # container_port= 443
    java_secret      = var.java_secret
    container_cpu    = var.container_cpu
    container_memory = var.container_memory
    # aws_region     = var.aws_region
    #Added for OneAgent
    ld_preload_cmd            = var.ld_preload_cmd
    dependent_container_name  = var.oneag_container_name
    ag_container_name         = var.oneag_container_name
    ag_container_image        = join(":", [var.oneag_container_image, var.oneag_container_image_version])
    ag_command                = var.oneag_command
    dt_api_url                = var.oneag_api_url
    dt_oneagent_options       = var.oneag_options
    dt_pass_token             = var.oneag_pass_token
    buss_cont_SourceVolume    = var.oneag_taskvol
    buss_cont_ContainerVol    = var.oneag_container_path
    oneAgent_SourceVolume     = var.oneag_taskvol
    oneAgent_ContainerVol     = var.oneag_container_path
    log_configuration_auth_ag = var.log_configuration_auth_new
  }
}

resource "aws_ecs_task_definition" "task5" {
  family                   = var.container_name5
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_execution_role_arn
  container_definitions    = data.template_file.auth.rendered
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  requires_compatibilities = ["FARGATE"]
  skip_destroy             = true
  tags                     = local.common_tags
  volume {
    name = var.oneag_taskvol
  }
}

data "template_file" "field" {
  template = file("task_json/field.json")

  vars = {
    app_name                    = var.app_name6
    container_name6             = var.container_name6
    container_image6            = "${var.container_image6}:${var.fdash-field-service-image}"
    container_port6             = var.container_port6
    log_configuration_field_new = var.log_configuration_field_new
    host_port6                  = var.host_port6
    # container_port= 443
    env                    = var.env
    infra                  = "normal"
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
    log_configuration_field_new_ag = var.log_configuration_field_new
  }
}

resource "aws_ecs_task_definition" "task6" {
  family                   = var.container_name6
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_execution_role_arn
  container_definitions    = data.template_file.field.rendered
  cpu                      = var.pythoncontainer_cpu
  memory                   = var.pythoncontainer_memory
  requires_compatibilities = ["FARGATE"]
  skip_destroy             = true
  tags                     = local.common_tags
  volume {
    name = var.oneag_taskvol
  }
}

data "template_file" "audit" {
  template = file("task_json/audit.json")

  vars = {
    app_name                = var.app_name7
    container_name7         = var.container_name7
    container_image7        = "${var.container_image7}:${var.fdash-audit-service-image}"
    container_port7         = var.container_port7
    log_configuration_audit = var.log_configuration_audit_new
    host_port7              = var.host_port7
    # container_port= 443
    java_secret      = var.java_secret
    container_cpu    = var.container_cpu
    container_memory = var.container_memory
    # aws_region     = var.aws_region
    #Added for OneAgent
    ld_preload_cmd             = var.ld_preload_cmd
    dependent_container_name   = var.oneag_container_name
    ag_container_name          = var.oneag_container_name
    ag_container_image         = join(":", [var.oneag_container_image, var.oneag_container_image_version])
    ag_command                 = var.oneag_command
    dt_api_url                 = var.oneag_api_url
    dt_oneagent_options        = var.oneag_options
    dt_pass_token              = var.oneag_pass_token
    buss_cont_SourceVolume     = var.oneag_taskvol
    buss_cont_ContainerVol     = var.oneag_container_path
    oneAgent_SourceVolume      = var.oneag_taskvol
    oneAgent_ContainerVol      = var.oneag_container_path
    log_configuration_audit_ag = var.log_configuration_audit_new
  }
}

resource "aws_ecs_task_definition" "task7" {
  family                   = var.container_name7
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_execution_role_arn
  container_definitions    = data.template_file.audit.rendered
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  requires_compatibilities = ["FARGATE"]
  skip_destroy             = true
  tags                     = local.common_tags
  volume {
    name = var.oneag_taskvol
  }
}

data "template_file" "comparison" {
  template = file("task_json/comparison.json")

  vars = {
    app_name                     = var.app_name8
    container_name8              = var.container_name8
    container_image8             = "${var.container_image8}:${var.fdash-comparison-service-image}"
    container_port8              = var.container_port8
    log_configuration_comparison = var.log_configuration_comparison_new
    host_port8                   = var.host_port8
    # container_port= 443
    java_secret      = var.java_secret
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
    log_configuration_comparison_ag = var.log_configuration_comparison_new
  }
}

resource "aws_ecs_task_definition" "task8" {
  family                   = var.container_name8
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_execution_role_arn
  container_definitions    = data.template_file.comparison.rendered
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  requires_compatibilities = ["FARGATE"]
  skip_destroy             = true
  tags                     = local.common_tags
  volume {
    name = var.oneag_taskvol
  }
}

data "template_file" "integration" {
  template = file("task_json/integration.json")

  vars = {
    app_name                      = var.app_name9
    container_name9               = var.container_name9
    container_image9              = "${var.container_image9}:${var.fdash-integration-service-image}"
    container_port9               = var.container_port9
    log_configuration_integration = var.log_configuration_integration_new
    host_port9                    = var.host_port9
    # container_port= 443
    java_secret      = var.java_secret
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
    log_configuration_integration_ag = var.log_configuration_integration_new
  }
}

resource "aws_ecs_task_definition" "task9" {
  family                   = var.container_name9
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_execution_role_arn
  container_definitions    = data.template_file.integration.rendered
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  requires_compatibilities = ["FARGATE"]
  skip_destroy             = true
  tags                     = local.common_tags
  volume {
    name = var.oneag_taskvol
  }
}

data "template_file" "wrapper" {
  template = file("task_json/wrapper.json")

  vars = {
    app_name                  = var.app_name10
    container_name10          = var.container_name10
    container_image10         = "${var.container_image10}:${var.fdash-wrapper-service-image}"
    container_port10          = var.container_port10
    log_configuration_wrapper = var.log_configuration_wrapper_new
    host_port10               = var.host_port10
    # container_port= 443
    java_secret      = var.java_secret
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
    log_configuration_wrapper_ag = var.log_configuration_wrapper_new
  }
}

resource "aws_ecs_task_definition" "task10" {
  family                   = var.container_name10
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_execution_role_arn
  container_definitions    = data.template_file.wrapper.rendered
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  skip_destroy             = true
  requires_compatibilities = ["FARGATE"]
  tags                     = local.common_tags
  volume {
    name = var.oneag_taskvol
  }
}

data "template_file" "stitching" {
  template = file("task_json/stitching.json")

  vars = {
    app_name                    = var.app_name11
    container_name11            = var.container_name11
    container_image11           = "${var.container_image11}:${var.fdash-stitching-service-image}"
    container_port11            = var.container_port11
    log_configuration_stitching = var.log_configuration_stitching_new
    host_port11                 = var.host_port11
    # container_port= 443
    java_secret      = var.java_secret
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
    log_configuration_stitching_ag = var.log_configuration_stitching_new
  }
}

resource "aws_ecs_task_definition" "task11" {
  family                   = var.container_name11
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_execution_role_arn
  container_definitions    = data.template_file.stitching.rendered
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  requires_compatibilities = ["FARGATE"]
  skip_destroy             = true
  tags                     = local.common_tags

  volume {
    name = var.oneag_taskvol
  }
}

