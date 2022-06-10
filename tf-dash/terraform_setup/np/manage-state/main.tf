provider "aws" {
  region = "us-east-1"
}

# These steps are derived from this guide: https://blog.gruntwork.io/how-to-manage-terraform-state-28f5697e68fa
resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-fhmc-np"
  acl = "private"

  # Enable versioning so we can see the full revision history of our
  # state files
  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Description = "Stores terraform state for non prod"
    Environment = "NP"
    AppOwner = "EA"
    CostCenter = "Corporate"
    InstanceManager = "EA"
    AppName = "Terraform"
  }
}
resource "aws_s3_bucket_public_access_block" "private_bucket" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}
resource "aws_dynamodb_table" "terraform_locks" {
  name = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
