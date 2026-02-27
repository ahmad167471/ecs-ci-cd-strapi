output "log_group_name" {
  description = "The name of the CloudWatch log group created for ECS tasks"
  value       = aws_cloudwatch_log_group.ecs.name
}

output "log_group_arn" {
  description = "The ARN of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.ecs.arn
}