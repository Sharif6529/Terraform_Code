data "template_file" "user_data" {
  template = file("templates/user-data.sh")
  vars = {
    cluster_name = "${var.app}-${var.env}"
  }
}

data "template_file" "user_data_msr" {
  template = file("templates/user-data.sh")
  vars = {
    cluster_name = "${var.app}-MSR-${var.env}"
  }
}

data "template_file" "user_data_pri" {
  template = file("templates/user-data.sh")
  vars = {
    cluster_name = "${var.app}-PRI-${var.env}"
  }
}
# resource "aws_instance" "this" {
#   count                  = var.ec2_count
#   ami                    = var.ec2_ami
#   instance_type          = var.instance_type
#   subnet_id              = var.subnets[count.index % length(var.subnets)]
#   iam_instance_profile   = var.ec2_profile
#   key_name               = var.ec2_key
#   vpc_security_group_ids = [aws_security_group.cluster-sg.id]
#   user_data              = data.template_file.user_data.rendered

#   tags = merge(local.common_tags, {

#     Name            = "${var.ec2_name_prefix}${format("%02g", count.index + 1)}"
#     Environment     = "${var.env}"
#     InstanceManager = "Unix"
#     AppOwner        = "Samir Shah"
#     BusinessUnit    = "Information Technology"
#     CostCenter      = "Corporate"
#     AppName         = "Dash"
#   })

#   credit_specification {
#     cpu_credits = "standard"
#   }
#   root_block_device {
#     volume_size = var.ebs_size
#     volume_type = var.ebs_type
#     encrypted   = true
#     kms_key_id  = var.ebs_kms_id
#   }
# }

locals {
  ec2_tags_map = merge(local.common_tags, {

    Name            = "${var.ec2_name_prefix}"
    Environment     = "${var.env}"
    InstanceManager = "Unix"
    BusinessUnit    = "Information Technology"
    CostCenter      = "Corporate"
    AppName         = "Dash"
  })
  # ec2_tags = toset(values(ec2_tags_map))
}

resource "aws_launch_configuration" "launch" {
  name_prefix          = "aws-asg-"
  image_id             = var.ec2_ami
  instance_type        = var.instance_type
  user_data            = data.template_file.user_data.rendered
  iam_instance_profile = var.ec2_profile
  # user_data       = "#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.cluster.name} >> /etc/ecs/ecs.config"
  security_groups = [aws_security_group.cluster-sg.id]

  lifecycle {
    create_before_destroy = true
  }
  root_block_device {
    volume_size = var.ebs_size
    volume_type = var.ebs_type
    encrypted   = true
  }
  ebs_optimized = true
}

resource "aws_launch_configuration" "launch_pri" {
  name_prefix          = "aws-asg-"
  image_id             = var.ec2_ami
  instance_type        = var.instance_type
  user_data            = data.template_file.user_data_pri.rendered
  iam_instance_profile = var.ec2_profile
  # user_data       = "#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.cluster.name} >> /etc/ecs/ecs.config"
  security_groups = [aws_security_group.cluster-sg.id]

  lifecycle {
    create_before_destroy = true
  }
  root_block_device {
    volume_size = var.ebs_size
    volume_type = var.ebs_type
    encrypted   = true
  }
  ebs_optimized = true
}

resource "aws_launch_configuration" "launch_msr" {
  name_prefix          = "aws-asg-"
  image_id             = var.ec2_ami
  instance_type        = var.instance_type
  user_data            = data.template_file.user_data_msr.rendered
  iam_instance_profile = var.ec2_profile
  # user_data       = "#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.cluster.name} >> /etc/ecs/ecs.config"
  security_groups = [aws_security_group.cluster-sg.id]

  lifecycle {
    create_before_destroy = true
  }
  root_block_device {
    volume_size = var.ebs_size
    volume_type = var.ebs_type
    encrypted   = true
  }
  ebs_optimized = true
}

# resource "aws_placement_group" "dash-pg" {
#   name     = "dash"
#   strategy = "cluster"
# }

resource "aws_autoscaling_group" "ec2-asg" {
  name             = "ec2-asg-${var.env}"
  min_size         = var.ec2_count
  max_size         = var.max_capacity
  desired_capacity = var.ec2_count
  # placement_group      = aws_placement_group.dash-pg.id
  launch_configuration = aws_launch_configuration.launch.name
  vpc_zone_identifier  = var.subnets
  capacity_rebalance   = true
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
  metrics_granularity = "1Minute"
  tag {
    key                 = "ClusterName"
    value               = aws_ecs_cluster.cluster.name
    propagate_at_launch = true
  }
  tag {
    key                 = "AmazonECSManaged"
    value               = ""
    propagate_at_launch = true
  }
  dynamic "tag" {
    for_each = local.ec2_tags_map
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true

    }
  }
}

resource "aws_autoscaling_group" "ec2-asg_msr" {
  name             = "ec2-asg-msr-${var.env}"
  min_size         = var.ec2_count
  max_size         = 100
  desired_capacity = var.ec2_count
  # placement_group      = aws_placement_group.dash-pg.id
  launch_configuration = aws_launch_configuration.launch_msr.name
  vpc_zone_identifier  = var.subnets
  capacity_rebalance   = true
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
  metrics_granularity = "1Minute"
  # tag {
  #   key                 = "ClusterName"
  #   value               = aws_ecs_cluster.cluster_msr.name
  #   propagate_at_launch = true
  # }
  tag {
    key                 = "AmazonECSManaged"
    value               = ""
    propagate_at_launch = true
  }
  dynamic "tag" {
    for_each = local.ec2_tags_map
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true

    }
  }
}

resource "aws_autoscaling_group" "ec2-asg_pri" {
  name             = "ec2-asg-pri-${var.env}"
  min_size         = var.ec2_count
  max_size         = var.max_capacity
  desired_capacity = var.ec2_count
  # placement_group      = aws_placement_group.dash-pg.id
  launch_configuration = aws_launch_configuration.launch_pri.name
  vpc_zone_identifier  = var.subnets
  capacity_rebalance   = true
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
  metrics_granularity = "1Minute"
  # tag {
  #   key                 = "ClusterName"
  #   value               = aws_ecs_cluster.cluster_pri.name
  #   propagate_at_launch = true
  # }
  tag {
    key                 = "AmazonECSManaged"
    value               = ""
    propagate_at_launch = true
  }
  dynamic "tag" {
    for_each = local.ec2_tags_map
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true

    }
  }
}

# resource "aws_ecs_capacity_provider" "capacity_provider" {
#   name = "FDASH-capacity-provider-EC2"
#   auto_scaling_group_provider {
#     auto_scaling_group_arn = aws_autoscaling_group.ec2-asg.arn
#     managed_scaling {
#       status                    = "ENABLED"
#       target_capacity           = 70
#       maximum_scaling_step_size = 5
#       minimum_scaling_step_size = 2
#     }
#   }
# }

# resource "aws_ecs_cluster_capacity_providers" "ecs_capacity_provider" {
#   cluster_name = aws_ecs_cluster.cluster.name

#   capacity_providers = [aws_ecs_capacity_provider.capacity_provider.name]
#   default_capacity_provider_strategy {
#     base              = 1
#     weight            = 100
#     capacity_provider = aws_ecs_capacity_provider.capacity_provider.name
#   }
# }