# # Outputs from VPC Module
# output "vpc_public_subnet_ids" {
#   description = "IDs of the public subnets in the VPC"
#   value       = module.vpc.public_subnet_ids
# }

# output "vpc_security_group_id" {
#   description = "ID of the security group associated with the linux instances"
#   value       = module.vpc.security_group_id
# }

# # Outputs for EC2 Instances
# output "ec2_instance_ids" {
#   description = "IDs of the EC2 instances for Kubernetes nodes"
#   value       = aws_instance.k8s_node[*].id
# }

# output "ec2_public_ip_addresses" {
#   description = "Public IP addresses of the EC2 instances for Kubernetes nodes"
#   value       = aws_instance.k8s_node[*].public_ip
# }

# output "ec2_private_ip_addresses" {
#   description = "Private IP addresses of the EC2 instances for Kubernetes nodes"
#   value       = aws_instance.k8s_node[*].private_ip
# }

# output "ec2_public_dns" {
#   description = "Public DNS names of the EC2 instances for Kubernetes nodes"
#   value       = [for instance in aws_instance.k8s_node : instance.public_dns]
# }

# output "ec2_count" {
#   description = "Number of EC2 instances provisioned for Kubernetes nodes"
#   value       = length(aws_instance.k8s_node)
# }


#######################################################################
# output "public_subnet_ids" {
#   value = aws_subnet.public.*.id
# }

# output "security_group_id" {
#   description = "ID of the Linux security group"
#   value       = aws_security_group.linux_security_group.id
# }

# output "master_security_group_id" {
#   description = "ID of the master node security group"
#   value       = aws_security_group.master.id
# }

# output "worker_security_group_id" {
#   description = "ID of the worker node security group"
#   value       = aws_security_group.worker.id
# }
