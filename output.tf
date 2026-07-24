output "public_subnets" {
  value       = module.vpc.public_subnets
}

# Inside modules/security_group/outputs.tf
output "security_group_id" {
  value = module.security_group.id
}