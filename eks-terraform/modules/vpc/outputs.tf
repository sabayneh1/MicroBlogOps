output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "eks_cluster_sg_id" {
  value = aws_security_group.eks_cluster_sg.id
}
