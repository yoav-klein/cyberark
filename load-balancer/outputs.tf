
output "target_group_arn" {
  value       = module.alb.target_group_arns[0]
  description = "ARN of target group created"
}

output "dns_name" {
  description = "DNS name of load balancer"
  value       = module.alb.lb_dns_name
}
