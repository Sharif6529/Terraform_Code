aws_profile = "poc"
aws_region  = "us-east-1"
env         = "poc"
appName     = "edm-pasoe"

# Networking
vpc_id    = "vpc-064f4ecfbdb8d691e"
subnets   = ["subnet-06285b527bbe4496e", "subnet-0393b187196edf93f"]
cert_arn  = "arn:aws:acm:us-east-1:211385148200:certificate/163f2c2a-459c-4cf1-aec8-16bb3a32d8c9" #fhmcpoc.cloud
cidr_list = ["172.17.0.0/21"]

# EC2
ec2_ami         = "ami-0643e99783bc46e02"
instance_type   = "t3.medium"
ec2_subnet      = "subnet-06285b527bbe4496e"
ec2_profile     = "ecsInstanceRole"
ec2_key         = "" # this is disabled in the AMI.
ec2_cpu_credits = "standard"
ebs_type        = "gp3"
ebs_size        = 30
ebs_kms_id      = "arn:aws:kms:us-east-1:211385148200:key/7038cf53-4855-4030-b89b-a064f9f40fcd"

# ALB
albLogBucket     = "fhmc-poc-logs"
health_check_url = "/edm" # no conn to the DB, so the hc would fail
ssl_policy       = "ELBSecurityPolicy-FS-1-2-2019-08"

# Environment Variables
catalina_out  = "/proc/1/fd/1"
instance_name = "oepas1"

# Container
container_name   = "edmweb"
container_image  = "996190702173.dkr.ecr.us-east-1.amazonaws.com/edm-pasoe:latest"
container_cpu    = "1024" # 1 vCPU
container_memory = "2048" # 2GB ram
container_port   = 8811
host_port        = 8811
desireCount      = 1
volumes = [
  { name = "docs", host_path = "/docs" },
  { name = "documents", host_path = "/docs/documents" },
  { name = "tmp", host_path = "/docimg/tmp" },
  { name = "da01", host_path = "/da01" }
]
mount_points = [
  { "sourceVolume" : "docs", "containerPath" : "/docs" },
  { "sourceVolume" : "documents", "containerPath" : "/documents" },
  { "sourceVolume" : "tmp", "containerPath" : "/docimg/tmp" },
  { "sourceVolume" : "da01", "containerPath" : "/da01" }
]

# Autoscaling
/*min_capacity = 0
max_capacity = 2
min_size     = 0
max_size     = 4
high_threshold = "20"
low_threshold = "10"
scale_up_adjustment = 1
scale_up_cooldown = 60
scale_down_adjustment = -1
scale_down_cooldown = 300*/
