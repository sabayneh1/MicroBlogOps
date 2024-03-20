output "public_subnet_ids" {
  value = [for subnet in aws_subnet.public : subnet.id]
}


output "master_security_group_id" {
  value = aws_security_group.master.id
}

output "worker_security_group_id" {
  value = aws_security_group.worker.id
}


output "private_subnet_ids" {
  value = aws_subnet.private[*].id
  description = "List of IDs of private subnets"
}
