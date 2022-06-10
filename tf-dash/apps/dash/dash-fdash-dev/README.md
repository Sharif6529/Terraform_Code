This component builds out a DASH-UI-API container instance in ECS using an AMI produced by the Unix team.

# Services included
- ALB
- ECS / Task Definition / Service
- 2 Security Groups (Web, Compute)
- IAM - Execution role for the ECS Task
- Autoscaling group

# Todo
- Need to create ECR

# Commands to run it
## POC
### Init
```bash
terraform init \
  -backend-config="region=us-east-2" \
  -backend-config="bucket=terraform-state-fhmc-poc" \
  -backend-config="key=poc/apps/dash/dash-fdash-dev/terraform.tfstate" \
  -backend-config="profile=poc" \
  -backend=true
```
### Plan
```bash
terraform plan -var-file=envs/poc.tfvars
```
### Apply
```bash
terraform apply -var-file=envs/poc.tfvars
```

## Dev
### Init
```bash
terraform init \
  -backend-config="region=us-east-1" \
  -backend-config="bucket=terraform-state-fhmc-np" \
  -backend-config="key=dev/apps/dash/dash-fdash-dev/terraform.tfstate" \
  -backend-config="profile=default" \
  -backend=true
```
### Plan
```bash
terraform plan -var-file=envs/dev.tfvars
```
### Apply
```bash
terraform apply -var-file=envs/dev.tfvars
```

## Prod
### Init
```bash
terraform init \
  -backend-config="region=us-east-1" \
  -backend-config="bucket=terraform-state-fhmc-prod" \
  -backend-config="key=prod/apps/dash/dash-fdash-dev/terraform.tfstate" \
  -backend-config="profile=prod" \
  -backend=true
```
### Plan
```bash
terraform plan -var-file=envs/prod.tfvars
```
### Apply
```bash
terraform apply -var-file=envs/prod.tfvars
```
