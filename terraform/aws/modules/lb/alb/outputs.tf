output "alb_arn" {
  description = "The ARN of the ALB"
  value       = module.alb.arn
}

output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = module.alb.dns_name
}

output "alb_zone_id" {
  description = "The zone id of the ALB"
  value       = module.alb.zone_id
}
