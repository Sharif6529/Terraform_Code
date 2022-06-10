# Terraform Setup

These are the steps used to setup Terraform in the first place with state shared and backed up in S3, and using Dynamo for locks. This is a one-time setup task and state isn't saved to S3 since it has to be created first.