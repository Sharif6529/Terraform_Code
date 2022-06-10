# Terraform Overview
The current approach that was taken was to generate all the infrastructure configured in the terraform_setup folder. Then create folders based on app.

## Standards
1. We use an S3 backend with Dynamo for locking
1. Have separation between Prod and NonProd with separate backends for each
1. Keep modules small. They should perform one task really well. Use outputs to chain them together.
1. Isolation via File Layout, not Workspaces

## Folder Structure

/apps / <app> / <component name>
   /envs
   /tests

/examples

/modules

/terraform_setup



## Open Issues

1. Need to move to modules
