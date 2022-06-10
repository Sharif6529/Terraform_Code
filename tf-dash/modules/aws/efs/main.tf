data "aws_region" "current" {}
locals {
  dns_name = "${join("", aws_efs_file_system.default.*.id)}.efs.${data.aws_region.current.name}.amazonaws.com"
}

resource "aws_efs_file_system" "default" {
  count                           = var.enabled ? 1 : 0
  creation_token                  = var.creation_token
  tags                            = var.tags
  encrypted                       = var.encrypted
  performance_mode                = var.performance_mode
  provisioned_throughput_in_mibps = var.provisioned_throughput_in_mibps
  throughput_mode                 = var.throughput_mode
  kms_key_id                      = var.kms_key_id

  dynamic "lifecycle_policy" {
    for_each = var.transition_to_ia == "" ? [] : [1]
    content {
      transition_to_ia = var.transition_to_ia
    }
  }
}

resource "aws_efs_mount_target" "default" {
  count           = var.enabled && length(var.subnets) > 0 ? length(var.subnets) : 0
  file_system_id  = join("", aws_efs_file_system.default.*.id)
  ip_address      = var.mount_target_ip_address
  subnet_id       = var.subnets[count.index]
  security_groups = var.security_groups
}
resource "aws_efs_access_point" "default" {
  for_each = var.access_points

  file_system_id = join("", aws_efs_file_system.default.*.id)

  posix_user {
    gid = var.access_points[each.key]["posix_user"]["gid"]
    uid = var.access_points[each.key]["posix_user"]["uid"]
    # Just returning null in the lookup function gives type errors and is not omitting the parameter, this work around ensures null is returned.
    secondary_gids = lookup(lookup(var.access_points[each.key], "posix_user", {}), "secondary_gids", null) == null ? null : null
  }

  root_directory {
    path = "/${each.key}"
    creation_info {
      owner_gid   = var.access_points[each.key]["creation_info"]["gid"]
      owner_uid   = var.access_points[each.key]["creation_info"]["uid"]
      permissions = var.access_points[each.key]["creation_info"]["permissions"]
    }
  }

  tags = var.tags
}