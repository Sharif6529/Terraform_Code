output "sqs_name" {
    value = aws_sqs_queue.this.*.name
}

output "sqs_arn" {
    value = aws_sqs_queue.this.*.arn
}


