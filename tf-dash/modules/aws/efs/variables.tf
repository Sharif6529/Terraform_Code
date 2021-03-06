#EFS File system
variable "enabled" {
  type        = bool
  description = "Set to false to prevent the module from creating any resources"
  default     = true
}
variable "creation_token" {
  type        = string
  description = "A unique name (a maximum of 64 characters are allowed) used as reference when creating the EFS"
}
variable "tags" {
  type        = map(string)
  description = "tags (e.g. `{ BusinessUnit = \"XYZ\" }`"
  default     = {}
}
variable "encrypted" {
  type        = bool
  description = "If true, the file system will be encrypted"
  default     = true
}

variable "performance_mode" {
  type        = string
  description = "The file system performance mode. Can be either `generalPurpose` or `maxIO`"
  default     = "generalPurpose"
}

variable "provisioned_throughput_in_mibps" {
  default     = 0
  description = "The throughput, measured in MiB/s, that you want to provision for the file system. Only applicable with `throughput_mode` set to provisioned"
}
variable "kms_key_id" {
  type        = string
  description = "The ARN for the KMS encryption key. When specifying kms_key_id, encrypted needs to be set to true."
  default     = ""
}
variable "throughput_mode" {
  type        = string
  description = "Throughput mode for the file system. Defaults to bursting. Valid values: `bursting`, `provisioned`. When using `provisioned`, also set `provisioned_throughput_in_mibps`"
  default     = "bursting"
}
variable "transition_to_ia" {
  type        = string
  description = "Indicates how long it takes to transition files to the IA storage class. Valid values: AFTER_7_DAYS, AFTER_14_DAYS, AFTER_30_DAYS, AFTER_60_DAYS and AFTER_90_DAYS"
  default     = ""
}
#EFS mount target
variable "mount_target_ip_address" {
  type        = string
  description = "The address (within the address range of the specified subnet) at which the file system may be mounted via the mount target"
  default     = ""
}
variable "subnets" {
  type        = list(string)
  description = "Subnet IDs"
}
variable "security_groups" {
  type        = list(string)
  description = "Security group IDs to allow access to the EFS"
}
variable "access_points" {
  type        = map(map(map(any)))
  default     = {}
  description = "A map of the access points you would like in your EFS volume"
}
