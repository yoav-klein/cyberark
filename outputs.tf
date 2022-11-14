
output "lb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.alb.dns_name
}
