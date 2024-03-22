# # Outputs from VPC Module
# output "vpc_public_subnet_ids" {
#   description = "IDs of the public subnets in the VPC"
#   value       = module.vpc.public_subnet_ids
# }

# output "vpc_security_group_id" {
#   description = "ID of the security group associated with the linux instances"
#   value       = module.vpc.security_group_id
# }

output "master_ip" {
  value = module.master_node.master_node_ip
}
output "worker_ips" {
  value = module.worker_nodes.worker_node_ips
}
