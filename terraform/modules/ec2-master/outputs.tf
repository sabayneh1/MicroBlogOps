output "ec2_instance_ids" {
  value = aws_instance.k8s_node[*].id
}

output "ec2_public_ip_addresses" {
  value = aws_instance.k8s_node[*].public_ip
}

output "ec2_private_ip_addresses" {
  value = aws_instance.k8s_node[*].private_ip
}

output "ec2_public_dns" {
  value = [for instance in aws_instance.k8s_node : instance.public_dns]
  description = "Public DNS names of the EC2 instances."
}

output "ec2_count" {
  value = length(aws_instance.k8s_node)
}


# For the master node instance profile
output "master_node_iam_instance_profile_name" {
  value = aws_iam_instance_profile.ec2_profile.name
}

output "master_node_ip" {
  value = aws_instance.k8s_node[0].public_ip
}

