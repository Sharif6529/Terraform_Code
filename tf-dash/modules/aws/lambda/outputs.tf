
output "this_lambda_function_name" {
  description = "The name of the Lambda Function"
  value       = element(concat(aws_lambda_function.this.*.function_name, [""]), 0)
}

output "this_lambda_function_arn" {
  description = "The name of the bucket."
  value       = element(concat(aws_lambda_function.this.*.arn, [""]), 0)
}

output "lifecycle_lambda_function_name" {
  description = "The name of the Lambda Function"
  value       = element(concat(aws_lambda_function.lifecycle.*.function_name, [""]), 0)
}

output "lifecycle_lambda_function_arn" {
  description = "The name of the bucket."
  value       = element(concat(aws_lambda_function.lifecycle.*.arn, [""]), 0)
}